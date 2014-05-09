class RecipesController < ApplicationController
  before_filter :exist, only: [:show,:edit,:destroy]
  before_filter :is_public, only: [:show]
  before_filter :has_source_id_param, only: [:new]
  #before_filter :protected_due_copyright, only: [:show]
  before_filter :signed_in_user, only: [:new,:create,:update,:edit,:detroy]
  before_filter :load, only: [ :new, :create, :edit,:update]
  before_filter :correct_user,   only: [:edit, :update]

  # GET /recipes
  # GET /recipes.json
  def index
    #@recipes = Recipe.all
    
    if params[:source_id].nil?
      #@recipes = Recipe.joins(:source).where("user_id = ?",current_user.id)
      if params[:search]
        @recipes = Recipe.where("name like '%#{params[:search]}%' and shareable != 'f'")
        @recipes=@recipes.paginate(page: params[:page], per_page: 10)
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @recipes }
        end
      else
        if signed_in?
          @fav_recipes = Recipe.where("id in (?)", current_user.usersmarks.favorite.map{|m| m.recipe_id})
          @car_recipes = Recipe.where("id in (?)", current_user.usersmarks.cart.map{|m| m.recipe_id})
          @recipes = @fav_recipes + @car_recipes
          @recipes=@recipes.uniq
          @recipes=@recipes.paginate(page: params[:page], per_page: 10)

          respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @recipes }
          end
        else
          redirect_to root_path, notice: t(:permission_denied)
        end
      end
    else
      redirect_to root_path, notice: t(:permission_denied) unless signed_in?
      @recipes = Recipe.joins(:source).where("source_id = ?",params[:source_id]) if signed_in?
      @recipes=@recipes.paginate(page: params[:page], per_page: 10) if signed_in?
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    params[:id]=params[:id].split('-')[0] if params[:id]    
    
    @recipe = Recipe.find(params[:id])
    @desc=@recipe.description.gsub(/\n/, '<br/>')
    @desc= ActionController::Base.helpers.sanitize(@desc, tags: %w(b br))
    Recipe.where("source_id = ?",@recipe.source_id).each do |r|
      @desc=@desc.gsub(r.name, "<a href=#{url_for(r)}>#{r.name}</a>").html_safe
    end

    begin
      image=Google::Search::Image.new(:query => "#{@recipe.name}").first
      @link= image.uri
      rescue
        @link=no_image_url
    end

    @mark_type = 0
    mark=current_user.usersmarks.find_by_recipe_id(@recipe.id) if signed_in?
    @mark_type=mark.mark_type if mark
    
    @usernote=mark.note if mark

    #@link=""
    #x=0
    #Google::Search::Image.new(:query => "#{@recipe.name}").each do |image|
    #  @link = image.uri if x==0
    #  x=1
    #end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    @recipe = Recipe.new
    #@source=Source.find(params[:source_id])
    @recipe = @source.recipes.new if @source

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(params[:recipe])
    unless current_user.admin?
      @source=current_user.sources.first
      @recipe = @source.recipes.build(params[:recipe])
      #@recipe.shareable='f' #vem nil não é preciso 
    end

    respond_to do |format|
      if @recipe.save
        #format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        #format.json { render json: @recipe, status: :created, location: @recipe }
        #format.html { redirect_to new_portion_path(recipe_id: @recipe.id), notice: 'Recipe was successfully created.' }
        format.html { redirect_to portions_path(recipe_id: @recipe.id) }
      else
        format.html { render action: "new" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        #format.html { redirect_to source_path(@recipe.source, recipe_id: @recipe.id), notice: 'Recipe was successfully updated.' }
        #format.html { redirect_to source_path(@recipe.source, recipe_id: @recipe.id) }
        #flash[:success] = "Recipe was successfully updated."
        #format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.html { redirect_to @recipe }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :no_content }
    end
  end

  private
    def exist
      #puts params[:id].split('-')[0] if params[:id]
      params[:id]=params[:id].split('-')[0] if params[:id]
      unless Recipe.where("id = ?",params[:id]).first
        redirect_to root_path
      end
    end

    def is_public
      @recipe = Recipe.find(params[:id])
      unless @recipe.shareable? || current_user?(@recipe.user)
        redirect_to root_path, notice: t(:permission_denied) 
      end
    end

    def has_source_id_param
      if params[:source_id]
        @source=Source.find_by_id(params[:source_id])
        redirect_to root_path unless @source && current_user?(@source.user)
      else
        redirect_to root_path
      end
    end

    def correct_user
      @recipe = Recipe.find(params[:id])
      redirect_to root_path, notice: t(:permission_denied) unless Recipe.joins(:source).where("user_id = ?",current_user.id).include?(@recipe)
    end

    def load
      #@sources=Source.select('name,id').map{ |c| [c.name, c.id] }
      @sources=current_user.sources.select('name,id').map{ |c| [c.name, c.id] }
      @categories=Category.select('name,id').order('name').map{ |c| [c.name, c.id] }

      if @sources.nil? || @sources.size==0
        flash[:warning] = "You must create a source first."
        redirect_to new_source_path
      end
    end

    def protected_due_copyright
      @recipe = Recipe.find(params[:id])
      if @recipe.source.public?
        redirect_to root_path, notice: t(:copyright_lock)  unless current_user && current_user.admin?
      end
    end
end
