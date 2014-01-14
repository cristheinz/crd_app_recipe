class UserMailer < ActionMailer::Base
  #default from: "admin@bimbyfy.com"
  default from: "Bimbyfy <suporte@bimbyfy.com>"

  def welcome_email(user)
    @user = user
    @url  = "http://bimbyfy.com/signin"
    mail :to => user.email, :subject => t(:welcome_subject)
  end

  def password_reset(user)
    @user = user  
    mail :to => user.email, :subject => t(:reset_password)
  end

  def partnership_info(feedback)
    @feedback = feedback
    mail :to => feedback.email, :subject => t(:partnership)
  end

  def feedback_email(feedback)
    @feedback = feedback
    mail(to: "cristheinz@gmail.com", subject: "crd_app_recipe-feedback")
  end

end