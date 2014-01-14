class AssignmentsController < ApplicationController
  def new
  end

  def create
    #@ingredients = Ingredient.except(current_list).map(&:name)
    #@ingredients = Ingredient.find(:all,:select=>'name').map(&:name)
    name=params[:assignment][:name]
    i = Ingredient.find_by_name(name) 
    if i || (name.include?("%") && name!="%" && !name.include?("%%") && name.size>3)
      if assigned_in?
        current_list.push(name) unless current_list.include?(name)
      else
        assign_in([name])
      end
    else
      flash.now[:error] = 'Invalid ingredient'
    end
    #render 'static_pages/home'
    redirect_to root_url

  end

  def remove
    if assigned_in?
      name=params[:ingredient_name]
      #name=params[:ingredient_name].encode("utf-8")
      name=Ingredient.find_by_name(name).name unless name.include?("%")
      current_list.delete(name)
      deassign if current_list.empty?
      redirect_to root_url
    end
  end

  def destroy
    deassign
    redirect_to root_url
  end
end
