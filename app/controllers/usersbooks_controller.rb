class UsersbooksController < ApplicationController
  before_filter :signed_in_user

  def create
  	#u=Usersbook.where("user_id = #{current_user.id} and source_id=#{params[:usersbook][:source_id]}")
  	#unless u.size>0
  	u= current_user.usersbooks.find_by_source_id(params[:usersbook][:source_id])
  	if u
	  	u.destroy
	else
  		@ub = current_user.usersbooks.build(source_id: params[:usersbook][:source_id])
	  	@ub.save
  	end
  	
    respond_to do |format|
      #format.html { redirect_to sources_path, notice: "aaaaaa"  }
      format.html { redirect_to sources_path }
      format.js
    end

  end

  def destroy
  end
end