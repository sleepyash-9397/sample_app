class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: session_params[:email].downcase
    if user&.authenticate(session_params[:password])
      log_in user
      if session_params[:remember_me] == Settings.session.remember_me
        remember(user)
      else
        forget(user)
      end
      flash[:success] = Settings.code.login_success
      redirect_to user
    else
      flash[:danger] = Settings.code.login_failure
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
