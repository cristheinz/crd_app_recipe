class UsersmarksController < ApplicationController
  before_filter :signed_in_user

  def create
    u = current_user.usersmarks.find_by_recipe_id(params[:usersmark][:recipe_id])
    if u && params[:usersmark][:mark_type].to_i == 0  && u.note==""
      u.destroy
    else
      if u
        u.mark_type = params[:usersmark][:mark_type].to_i
        u.note = params[:usersmark][:note] if params[:usersmark][:note]
        u.save
      else 
        @um = current_user.usersmarks.build(recipe_id: params[:usersmark][:recipe_id], mark_type: params[:usersmark][:mark_type], note: params[:usersmark][:note])
        @um.save
      end
    end

    respond_to do |format|
      format.html { redirect_to sources_path }
      format.js
    end
  end

  def set
    if params[:r_id]
      current_shopping_list.each do |x|
        if x[:id] == params[:r_id].to_i
          x[:price]=params[:r_price]
        end
      end
      redirect_to usersmarks_path
    end
  end

  def index
    ids=current_user.usersmarks.cart.map{|m| m.recipe_id}

    set_cart(Portion.select("ingredients.id, ingredients.name").joins(:ingredient).where("recipe_id in (?)", ids).order("ingredients.name").group("ingredients.name").map{|x| {id: x.id, name: x.name, price: 0.00}})

    @ingredient_list = Portion.joins(:recipe).joins(:ingredient).where("recipe_id in (?)", ids).order("ingredients.name")


    @total = 0.0
    current_shopping_list.each do |x|
      @total = @total.to_f+x[:price].to_f
    end

  end

end