class SadhnaCardsController < ApplicationController
  include SadhnaCardHelper

  def new
    @sadhna_card = SadhnaCard.new
    @custom_method = "post"
    @custom_path = "/sadhna_cards"
  end  

  def download
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
      ', @year, @month).order(date: :desc)

    filename = "sadhna_" + current_user.id.to_s + "_" + @month.to_s + "_" + @year.to_s + ".csv"
    CSV.open(filename, "wb") do |csv|
      csv << valid_columns.values
      @sadhna_cards.each do |sc|
        values = []
        valid_columns.keys.each do |col|
          v = sc[col]
          if col == "reading"
            v = 0 if !v
            type = if sc.reading_type.present? then sc.reading_type else "mins" end
            values.push(v + " " + type)
          elsif col == "hearing" || col == "service"
            v = 0 if !v
            values.push(v + " mins")
          elsif col == "rest_time" || col == "wakeup"
            if v
              values.push(v.strftime("%I:%M%p"))
            else
              values.push(nil)
            end
          elsif col == "chad"
            values.push(get_chapter(v))
          else
            values.push(v)
          end

        end

        csv << values
      end
    end

    send_file filename, :disposition => 'attachment'
  end

  def index

    if params[:month].present? and params[:year].present?
      @month = params[:month]
      @year = params[:year]
    else
      @month = Date.today.strftime("%m")
      @year =  Date.today.strftime("%Y")
    end

    @sadhna_cards = current_user.sadhna_cards.where('extract(year  from date) = ? AND extract(month  from date) = ? 
      ', @year, @month).order(date: :desc)

    @months = [["01", "Jan"], ["02", "Feb"], ["03", "March"], ["04", "April"], 
    ["05", "May"], ["06", "June"], ["07", "July"], ["08", "August"], ["09", "Sept"], 
    ["10", "Oct"], ["11", "Nov"], ["12", "Dec"]]
    @years = []
    count = 0
    start = 1989
    while count < 50
      count += 1
      if start+count <= @year.to_i
        @years.push(start + count)
      end
    end

  end

  def create
    existing_sc = SadhnaCard.where(:date => params[:date], :user_id => current_user.id)
    if existing_sc.count > 0
      render :json => {:error => "Sadhana Card with this date exists"}, :status => 422
    else
      @sadhna_card = SadhnaCard.new(sadhna_card_params)
   
      if @sadhna_card.save
        render :json => {id: @sadhna_card.id}, :status => :ok
      else
        render 'new'
      end
    end
  end

  def show
    @sadhna_card = SadhnaCard.find(params[:id])
  end

  def edit

    @sadhna_card = SadhnaCard.find(params[:id])
    print @sadhna_card.wakeup.to_time
  end

  def update
    @sadhna_card = SadhnaCard.find(params[:id])
   
    if @sadhna_card.update(sadhna_card_update_params)
      render :json => {id: @sadhna_card.id}, :status => :ok
    else
      render 'edit'
    end
  end

  private

  def sadhna_card_update_params
    unless params[:hearing].present?
      params[:hearing] = 0
    end
    unless params[:reading].present?
      params[:reading] = 0
    end
    unless params[:service].present?
      params[:service] = 0
    end
    unless params[:japa_rounds].present?
      params[:japa_rounds] = 0
    end
    unless params[:chad].present?
      params[:chad] = 0
      params[:verses] = 0
    else
      params[:verses] = get_verses(params[:chad])
    end
    if params[:reading_type] == "Hrs"
      params[:reading] = params[:reading].to_i*60
      params[:reading_type] == "Mins"
    end
    { 
      :date => params[:date],
      :japa_rounds => params[:japa_rounds], 
      :hearing => if params[:hearing_type] == "Mins" then params[:hearing] else params[:hearing].to_i*60 end,
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => if params[:service_type] == "Mins" then params[:service] else params[:service].to_i*60 end, 
      :chad => params[:chad], 
      :verses => params[:verses], 
      :reading => params[:reading],
      :reading_type => params[:reading_type],
      :service_text => params[:service_text],
      :comments => params[:comments],
      :reading_book => params[:reading_book],
    }
  end

  def get_verses(chapter_value)
    chad_map.each do |ch|
      if ch[0] == chapter_value
        return ch[2]
      end
    end
    return 0
  end

  def sadhna_card_params
    unless params[:hearing].present?
      params[:hearing] = 0
    end
    unless params[:reading].present?
      params[:reading] = 0
    end
    unless params[:service].present?
      params[:service] = 0
    end
    unless params[:japa_rounds].present?
      params[:japa_rounds] = 0
    end
    unless params[:chad].present?
      params[:chad] = 0
    end
    unless params[:chad].present?
      params[:chad] = 0
      params[:verses] = 0
    else
      params[:verses] = get_verses(params[:chad])
    end
    if params[:reading_type] == "Hrs"
      params[:reading] = params[:reading].to_i*60
      params[:reading_type] == "Mins"
    end
    { 
      :date => params[:date],
      :japa_rounds => params[:japa_rounds], 
      :hearing => params[:hearing_type] == "Mins" ? params[:hearing] : params[:hearing].to_i*60, 
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => params[:service_type] == "Mins" ? params[:service] : params[:service].to_i*60, 
      :chad => params[:chad], 
      :verses => params[:verses], 
      :reading => params[:reading],
      :reading_type => params[:reading_type],
      :user_id => current_user.id,
      :service_text => params[:service_text],
      :comments => params[:comments],
      :reading_book => params[:reading_book],
    }
  end
end
