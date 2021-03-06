class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Case (1)
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = t("pw_resets.new.info")
        redirect_to root_url
    else
      flash.now[:danger] = t("pw_resets.new.danger")
      render "new"
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, t("pw_resets.edit.error"))
      render "edit"
    elsif @user.update(user_params)                     # Case (4)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t("pw_resets.edit.success")
      redirect_to @user
    else
      render "edit"                                     # Case (2)
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  
    def find_user
      @user = User.find_by(email: params[:email])
    rescue ActiveRecord::RecordNotFound
      redirect_to new_password_reset_url
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user&.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url 
      end
    end
    
    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = t("pw_resets.edit.expired")
        redirect_to new_password_reset_url
      end
    end
end
