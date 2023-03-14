class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(permit_params)
    if @user.save
      redirect_to @user
      flash[:success] = "Welcome to the Sample App!"
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def permit_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
