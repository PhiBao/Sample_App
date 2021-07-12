class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end
  
  def create
    @user = User.new(user_params) 
    if @user.save
      log_in @user
      flash[:success] = t("static_pages.welcome")
      redirect_to @user
    else 
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t("users.edit.updated")
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end