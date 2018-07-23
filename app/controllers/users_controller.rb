class UsersController < ApplicationController
  before_action :authorize, except: [:new, :index]
  before_action :logged_in_user, except: [:new, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per Settings.per_page
  end

  def new
    @user = User.new
  end

  def show
    return if @user
    flash[:notice] = t "messages.notice"
    render template: "static_pages/home"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t "messages.success"
      redirect_to @user
    else
      flash[:error] = t "messages.failure"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "messages.update_success"
      redirect_to @user
    else
      flash[:error] = t "messages.update_failure"
      render :edit
    end
  end

  def destroy
    if @user
      @user.destroy
      flash[:success] = t "messages.del_success"
      redirect_to users_url
    else
      flash[:error] = t "messages.del_failure"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "messages.login_danger"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def authorize
    @user = User.find_by_id params[:id]
    return if @user
    flash[:notice] = t "messages.notice"
    redirect_to root_url
  end
end
