class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token  

  def new
    @user = User.new
  end

  def update_rounds
    current_user.name = params[:name]
    current_user.target_rounds = params[:target_rounds]
    current_user.save

    redirect_to :back
  end

  def edit

  end

  def index
    @total_rounds = 0
    @total_reading_hours = 0
    @total_hearing_hours = 0
    @total_service_hours = 0
    @total_sadhna_cards = 0
    @total_verses = 0

    @current_month_rounds = 0
    @current_month_reading_hours = 0
    @current_month_hearing_hours = 0
    @current_month_service_hours = 0
    @current_month_sadhna_cards = 0
    @current_month_verses = 0

    @month_name = Date.today.strftime("%B")
    @month = Date.today.strftime("%m")
    @year =  Date.today.strftime("%Y")

    sadhna_cards = current_user.sadhna_cards
    current_month_sadhna_cards = current_user.sadhna_cards.where('extract(year from date) = ? AND extract(month  from date) = ? 
      ', @year, @month)

    sadhna_cards.each do |sc|
      @total_rounds += sc.japa_rounds
      @total_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @total_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @total_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
      @total_verses += if sc.verses.present? then sc.verses else 0 end
    end
    @total_service_hours = (@total_service_hours/60).to_s + "h " +  (@total_service_hours % 60).to_s + "m"
    @total_reading_hours = (@total_reading_hours/60).to_s + "h " +  (@total_reading_hours % 60).to_s + "m"
    @total_hearing_hours = (@total_hearing_hours/60).to_s + "h " +  (@total_hearing_hours % 60).to_s + "m"
    @total_sadhna_cards = sadhna_cards.count

    current_month_sadhna_cards.each do |sc|
      @current_month_rounds += sc.japa_rounds
      @current_month_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @current_month_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @current_month_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
      @current_month_verses += if sc.verses.present? then sc.verses else 0 end
    end
    @current_month_service_hours = (@current_month_service_hours/60).to_s + "h " +  (@current_month_service_hours % 60).to_s + "m"
    @current_month_reading_hours = (@current_month_reading_hours/60).to_s + "h " +  (@current_month_reading_hours % 60).to_s + "m"
    @current_month_hearing_hours = (@current_month_hearing_hours/60).to_s + "h " +  (@current_month_hearing_hours % 60).to_s + "m"
    @current_month_sadhna_cards = current_month_sadhna_cards.count
  end

  def badges
    user = current_user
    if params[:id].present? && current_user.role == 'admin'
      user = User.find(params[:id])
    end
      
    cards = user.sadhna_cards
    @unlocked_badges = []
    @locked_badges = []

    target_rounds = user.target_rounds
    if target_rounds == nil
      target_rounds = 16
    end

    @level_1_badges = [
      ["Chanted 108 total Japa Rounds", cards.sum(:japa_rounds) > 108],
      ["Read more than 24 hours", cards.pluck(:reading).sum(&:to_i) > 24*60],
      ["Heard more than 24 hours", cards.pluck(:hearing).sum(&:to_i) > 24*60],
      ["Served more than 24 hours", cards.pluck(:service).sum(&:to_i) > 24*60],
      ["Chanted more than 16 rounds in one day", cards.where("japa_rounds > 16").count > 0],
      ["Served more than 2 hours in one day", cards.where("CAST(service AS INT) > ?", 120).count > 0],
      ["Read more than 2 hours in one day", cards.where("CAST(reading AS INT) > ?", 120).count > 0],
      ["Heard more than 2 hours in one day", cards.where("CAST(hearing AS INT) > ?", 120).count > 0],
      ["Recited 108 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)> 108],
      ["Chanted #{target_rounds} rounds every day in a week", chanted_minimum(user.sadhna_cards, target_rounds, 7)],
    ]

    @level_2_badges = [
      ["Chanted 1008 total Japa Rounds", cards.sum(:japa_rounds) > 1008],
      ["Read more than 168 hours(1 week)", cards.pluck(:reading).sum(&:to_i) > 24*7*60],
      ["Heard more than 168 hours(1 week)", cards.pluck(:hearing).sum(&:to_i) > 24*7*60],
      ["Served more than 168 hours(1 week)", cards.pluck(:service).sum(&:to_i)> 24*7*60],
      ["Recited 1008 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)> 1008],
      ["Chanted #{target_rounds} rounds every day in a month", chanted_minimum(user.sadhna_cards, target_rounds, 30)],
    ]
    
    @level_3_badges = [
      ["Chanted 10008 total Japa Rounds", cards.sum(:japa_rounds) > 10008],
      ["Read more than 720 hours(1 month)", cards.pluck(:reading).sum(&:to_i) > 24*30*60],
      ["Heard more than 720 hours(1 month)", cards.pluck(:hearing).sum(&:to_i) > 24*30*60],
      ["Served more than 720 hours(1 month)", cards.pluck(:service).sum(&:to_i)> 24*30*60],
      ["Recited 10008 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)> 10008],
      ["Chanted #{target_rounds} rounds every day in a year", chanted_minimum(user.sadhna_cards, target_rounds, 365)],
    ]

    @level_1_badges.each do |badge|
      if badge[1] == true
        @unlocked_badges.push(badge)
      else
        @locked_badges.push(badge)
      end
    end

    @level_2_badges.each do |badge|
      if badge[1] == true
        @unlocked_badges.push(badge)
      else
        @locked_badges.push(badge)
      end
    end
    
    @level_3_badges.each do |badge|
      if badge[1] == true
        @unlocked_badges.push(badge)
      else
        @locked_badges.push(badge)
      end
    end

  end

  def show
    @user = User.find(params[:id])

    @total_rounds = 0
    @total_reading_hours = 0
    @total_hearing_hours = 0
    @total_service_hours = 0
    @total_sadhna_cards = 0

    @current_month_rounds = 0
    @current_month_reading_hours = 0
    @current_month_hearing_hours = 0
    @current_month_service_hours = 0
    @current_month_sadhna_cards = 0

    @month_name = Date.today.strftime("%B")
    @month = Date.today.strftime("%m")
    @year =  Date.today.strftime("%Y")

    sadhna_cards = @user.sadhna_cards
    current_month_sadhna_cards = @user.sadhna_cards.where('extract(year from date) = ? AND extract(month  from date) = ? 
      ', @year, @month)

    sadhna_cards.each do |sc|
      @total_rounds += sc.japa_rounds
      @total_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @total_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @total_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
    end
    @total_service_hours = (@total_service_hours/60).to_s + "h " +  (@total_service_hours % 60).to_s + "m"
    @total_reading_hours = (@total_reading_hours/60).to_s + "h " +  (@total_reading_hours % 60).to_s + "m"
    @total_hearing_hours = (@total_hearing_hours/60).to_s + "h " +  (@total_hearing_hours % 60).to_s + "m"
    @total_sadhna_cards = sadhna_cards.count

    current_month_sadhna_cards.each do |sc|
      @current_month_rounds += sc.japa_rounds
      @current_month_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @current_month_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @current_month_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
    end
    @current_month_service_hours = (@current_month_service_hours/60).to_s + "h " +  (@current_month_service_hours % 60).to_s + "m"
    @current_month_reading_hours = (@current_month_reading_hours/60).to_s + "h " +  (@current_month_reading_hours % 60).to_s + "m"
    @current_month_hearing_hours = (@current_month_hearing_hours/60).to_s + "h " +  (@current_month_hearing_hours % 60).to_s + "m"
    @current_month_sadhna_cards = current_month_sadhna_cards.count
  end

  def report
    user = User.find(params[:id])

    if current_user != user && current_user.role != 'admin'
      render "_error"
      return
    end

    if params[:month].present? and params[:year].present?
      @month = params[:month]
      @year = params[:year]
    else
      @month = Date.today.strftime("%m")
      @year =  Date.today.strftime("%Y")
    end


    valid_columns = {
      "date" => "Date",
      "japa_rounds" => "Japa Rounds", 
      "reading" => "Reading Time",
      "reading_book" => "Book Read",
      "chad" => "CHAD (Chapter A Day)",
      "wakeup" => "Wake Up time", 
      "rest_time" => "Rest time", 
      "hearing" => "Hearing Time", 
      "service" => "Seva time",
      "service_text" => "Service executed",
      "comments" => "Comments"
    }

    @sadhna_cards = current_user.sadhna_cards.where('extract(year  from date) = ? AND extract(month  from date) = ? 
      ', @year, @month).order(date: :asc)


    @sadhna_cards_by_week = @sadhna_cards.each_slice(7).to_a
  end

  def chanted_minimum(cards, rounds, days)
    unless rounds.present?
      return false
    end
    cards = cards.order(date: :desc)

    count = 0
    cards.each do |card|
      if card.japa_rounds >= rounds
        count += 1
        if count == days
          return true
        end
      else
        count = 0
      end
    end
    return false
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
    render "new"
  end

end
