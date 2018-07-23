class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: session_params[:email].downcase
    if user&.authenticate(session_params[:password])
      log_in user
      if session_params[:remember_me] == Settings.session.remember_me.to_s
        remember(user)
      else
        forget(user)
      end
      flash[:success] = t "messages.login_success"
      redirect_back_or user
    else
      flash[:danger] = t "messages.login_failure"
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
