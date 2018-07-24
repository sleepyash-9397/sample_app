class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: session_params[:email].downcase
    if user&.authenticate(session_params[:password])
      if user.activated?
        log_in user
        if session_params[:remember_me] == Settings.session.remember_me.to_s
          remember(user)
        else
          forget(user)
        end
        redirect_back_or user
      else
        flash[:warning] = t "messages.check_email"
        redirect_to root_url
      end
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
    params.require(:session).permit :email, :password, :remember_me
  end
end
