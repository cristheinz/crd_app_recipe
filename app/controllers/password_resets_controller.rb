class PasswordResetsController < ApplicationController
  def new
  	
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user  
  	redirect_to root_url, :notice => t(:reset_password_msg) 
  end

  def edit  
  	@user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago  
      redirect_to new_password_reset_path, :alert => t(:expired_password_reset_msg)
    end
  end 

  def update
    @user = User.find_by_password_reset_token!(params[:id])  
    if @user.password_reset_sent_at < 2.hours.ago  
      redirect_to new_password_reset_path, :alert => t(:expired_password_reset_msg)
    elsif @user.update_attributes(params[:user])
      sign_in @user
      redirect_to root_url, :notice => t(:success_password_reset_msg)
    else  
      render :edit  
    end  
    end  
end
