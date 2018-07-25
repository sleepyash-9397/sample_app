class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by_email params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "messages.activate_email"
      redirect_to user
    else
      flash[:danger] = t "messages.notice_unactivate_email"
      redirect_to root_url
    end
  end
end
