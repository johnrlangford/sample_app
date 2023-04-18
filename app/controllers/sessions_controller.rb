class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      redirect_to session[:forwarding_url] || @user
      reset_session
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      session[:forwarding_url] = nil
    else
      flash.now[:danger] = "problem with username/password"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
