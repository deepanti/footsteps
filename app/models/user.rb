class User < ActiveRecord::Base
	has_many :skills
	has_many :mentors, :class_name => 'User'
  has_many :positions
  has_many :recommendations
  has_many :sadhna_cards

  include UsersHelper

  def authenticate(val)
    self.encrypted_password == val
  end

  def self.create_user_from_linkedin(access_token)
    url = "https://api.linkedin.com/v1/people/"
    url += "~:(positions,summary,id,num-connections,picture-url,location,industry,specialties,headline,first-name,last-name)"
    url += "?format=json&oauth2_access_token=#{access_token}&format=json-get"
    response = Typhoeus.get(url)
    if response.success?
      body = JSON.parse response.body
      user = User.new
      user.access_token = access_token
      user.name = body["firstName"]
      user.last_name = body["lastName"]
      user.industry = body["industry"]
      user.picture_url = body["pictureUrl"]
      user.headline = body["headline"]
      user.city = body["location"]["name"]
      user.country = body["location"]["country"]["code"]
      user.positions = []

      body["positions"]["values"].each do |pos|
        new_pos = Position.new(
            :company_name => pos["company"]["name"],
            :company_id => pos["company"]["id"],
            :title => pos["title"],
            :is_current => pos["isCurrent"],
            :location_name => pos["location"]["name"]
          )
        if pos["startDate"].present?
          new_pos.start_month = pos["startDate"]["month"]
          new_pos.start_year = pos["startDate"]["year"]
        end
        if pos["endDate"].present?
          new_pos.end_month = pos["endDate"]["month"]
          new_pos.end_year = pos["endDate"]["year"]
        end
        new_pos.save
        user.positions.push(new_pos)
      end
      user.save
    else
      raise "There was an error connecting to Linked in #{response.error}"
    end
    user
  end

  def upsert(records, new_record)
    found = false
    records.each do |record|
      if record[:school] == new_record[:school]
        record[:score] += 1.0
        found = true
      end
    end
    if !found
      records.push(new_record)
    end
    records
  end

  def compare(other_user)
    match = {
      :user => other_user,
      :is_mentor => false,
      :total_score => 0.0
    }

    match[:matched_records] = []
    
    self.positions.each do |pos|
      other_user.positions.each do |other_pos|
        if pos.company_name == other_pos.company_name
          match[:matched_records] = upsert(match[:matched_records], {
            :id => "SchoolIdentifierConstant",
            :score => 1.0,
            :school => pos.company_name
          })
          match[:total_score] += 1.0
        end
      end
    end

    self.skills.each do |skill|
      other_user.skills.each do |other_skill|
        if skill.name == other_skill.name
          match[:matched_records].push({
            :id => "SkillIdentifierConstant",
            :score => 1.0,
            :school => skill.name
          })
          match[:total_score] += 1.0
        end
      end
    end

    if self.industry == other_user.industry
      match[:matched_records].push({
        :id => "IndustryIdentifierConstant",
        :score => 1.0,
        :industry => self.industry
      })
      match[:total_score] += 1.0
    end

    if match[:total_score] > 0.0
      match[:is_mentor] = true
    end
    
    return match
  end

  def get_recommendations
    recommendations = UsersHelper.get_recommendations(self)
    # Sort in decreasing order of score
    recommendations[:recommended_users].sort! {|a,b| b["total_score"] <=> a["total_score"] }
    recommendations
  end

end
