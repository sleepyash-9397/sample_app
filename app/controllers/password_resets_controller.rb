class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by_email password_reset_params[:email].downcase
    if @user
      if @user.activated?
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = t "password_reset.info_reset_pass"
      else
        flash[:danger] = t "messages.let_unactivate_email"
      end
      redirect_to root_url
    else
      flash.now[:danger] = t "password_reset.danger_reset_pass"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("password_reset.password_empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attributes reset_digest: nil
      flash[:success] = t "password_reset.reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def password_reset_params
    params.require(:password_reset).permit :email
  end

  def get_user
    @user = User.find_by_email params[:email]
    return if @user.nil?
    flash[:danger] = t "messages.email_not_found"
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "password_reset.email_expired"
    redirect_to new_password_reset_url
  end
end
