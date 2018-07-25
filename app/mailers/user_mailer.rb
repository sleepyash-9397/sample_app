class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("subject.notice_email")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("subject.notice_reset_pass")
  end
end
