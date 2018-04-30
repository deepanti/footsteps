class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy, :forgot_password]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if !user
      @user = User.new(email: params[:session][:email], 
        encrypted_password: params[:session][:password],
        name: params[:session][:name])
      @user.save
      log_in @user
      redirect_to '/'
    else
      if user && user.authenticate(params[:session][:password])
        # Log the user in and redirect to the user's show page.
        log_in user
        redirect_to '/', :flash => { :notice  => "Welcome #{user.email}" }
      else
        # Create an error message.
        redirect_to '/', :flash => { :error  => "'Invalid email/password combination' " }
      end
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end
end