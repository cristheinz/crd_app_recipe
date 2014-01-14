class FeedbacksController < ApplicationController
  def create
    #if params['accept']
      @feedback = Feedback.new(params[:feedback])
      if @feedback.save
        UserMailer.feedback_email(@feedback).deliver
        UserMailer.partnership_info(@feedback).deliver
        #flash[:success] = "Obrigado!"
        redirect_to partnership_path, :notice => t(:reset_password_msg) 
      else
        render 'static_pages/partnership'
      end
    #else
    #  flash[:error] = "Deve concordar com os Termos e Condicoes"
    #  redirect_to partnership_path
    #end
  end
end
