class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by_id params[:id]
    return if @user
    flash[:notice] = Settings.code.notice
    render template: "static_pages/home"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = Settings.code.success
      redirect_to @user
    else
      flash[:error] = Settings.code.failure
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
