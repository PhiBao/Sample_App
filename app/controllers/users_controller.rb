class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: :show
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
<<<<<<< HEAD
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
=======
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
>>>>>>> a193bad (Add account activation)
  end
  
  def create
    @user = User.new(user_params) 
    if @user.save
      @user.send_activation_email
      flash[:info] = t("users.new.info")
      redirect_to root_url
    else 
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = t("users.edit.updated")
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def destroy
    if User.find(params[:id]).destroy
      flash[:success] = t("users.index.deleted")
    else
      flash[:danger] = t("users.index.failed")
    end
    redirect_to users_url
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t("global.not_found")
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    # Find a user
    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
end