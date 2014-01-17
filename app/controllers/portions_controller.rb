class PortionsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: [:show]
  before_filter :has_recipe_id_param, only: [:index]
  before_filter :load, only: [:index,:new, :create, :edit, :update]
  before_filter :set_ingredient, only: [:create, :update]
  # GET /portions
  # GET /portions.json
  def index
    @portion = Portion.new
    @ingredient=Ingredient.new
    @recipe=Recipe.find(params[:recipe_id])

    if !params[:recipe_id].nil?
      @recipe_id = params[:recipe_id]
      @portions = Portion.where('recipe_id = ?',params[:recipe_id]) 
    else
      current_user.sources.each do |source|
        source.recipes.each do |recipe|
          recipe.portions.each do |portion|
            @portions.push(portion)
          end
        end
      end
    end

    if @portions.nil?
      flash[:warning] = "You must create a recipe first."
      redirect_to new_recipe_path
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @portions }
      end
    end
  end

  # GET /portions/1
  # GET /portions/1.json
  def show
    @portion = Portion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @portion }
    end
  end

  # GET /portions/new
  # GET /portions/new.json
  def new
    @portion = Portion.new#(recipe_id: params[:recipe_id])
    @ingredient=Ingredient.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @portion }
    end
  end

  # GET /portions/1/edit
  def edit
    @portion = Portion.find(params[:id])
    @ingredient=Ingredient.find(@portion.ingredient_id)

  end

  # POST /portions
  # POST /portions.json
  def create
    @ingredient=Ingredient.new
    @portion = Portion.new(params[:portion])
    #unless @portion
    #  @recipe=Recipe.find(params[:portion][:recipe_id])
    #  @portion=@recipe.portions.build(params[:portion])
    #end

    respond_to do |format|
      if @portion.save
        #format.html { redirect_to portions_path(recipe_id: @portion.recipe_id), notice: 'Portion was successfully created.' }
        format.html { redirect_to portions_path(recipe_id: @portion.recipe_id) }
        #format.html { redirect_to @portion, notice: 'Portion was successfully created.' }
        #format.json { render json: @portion, status: :created, location: @portion }
      else
        #format.html { render action: "new", recipe_id: @portion.recipe_id }
        format.html { redirect_to portions_path(recipe_id: @portion.recipe_id) }
        format.json { render json: @portion.errors, status: :unprocessable_entity }

        flash[:error] = @portion.errors.first.join(" ").to_s
        #flash[:error] = "Deve seleccionar um ingrediente."
      end
    end
  end

  # PUT /portions/1
  # PUT /portions/1.json
  def update
    @portion = Portion.find(params[:id])

    respond_to do |format|
      if @portion.update_attributes(params[:portion])
        #format.html { redirect_to portions_path(recipe_id: @portion.recipe_id), notice: 'Portion was successfully updated.' }
        format.html { redirect_to portions_path(recipe_id: @portion.recipe_id) }
        #format.html { redirect_to @portion, notice: 'Portion was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @portion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portions/1
  # DELETE /portions/1.json
  def destroy
    @portion = Portion.find(params[:id])
    @portion.destroy

    respond_to do |format|
      format.html { redirect_to portions_path(recipe_id: @portion.recipe_id) }
      format.json { head :no_content }
    end
  end


  private
    def has_recipe_id_param
      redirect_to root_path unless params[:recipe_id]
      redirect_to root_path unless Recipe.find_by_id(params[:recipe_id]).user==current_user
    end

    def load
      @recipes=Recipe.select('name,id').map{ |c| [c.name, c.id] }
      @ingredients = Ingredient.find(:all,:select=>'name').map(&:name)
    end

    def set_ingredient
      unless params[:ingredient][:name].empty?
        ingredient = Ingredient.find_by_name(params[:ingredient][:name])
        #não deixo que se criem ingredientes
        #ingredient=Ingredient.create!(params[:ingredient]) if ingredient.nil? && current_user.admin?
        if ingredient
          params[:portion][:ingredient_id] = ingredient.id
        end
      end
    end

end
