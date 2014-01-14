class CategoriesController < ApplicationController
  before_filter :exist, only: [:show,:edit,:destroy]
  before_filter :signed_in_user, only: [:index,:new,:create,:update,:edit,:detroy]
  before_filter :admin_user, only: [:index,:new,:create,:update,:edit,:destroy]
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])
    recipes = @category.recipes.order("name")
    @recipes = recipes.joins(:source).where("sources.public = ?", true)
    if signed_in?
      ids = current_user.usersbooks.map {|b| b.source_id}
      @user_recipes = recipes.joins(:source).where("sources.public = ? and sources.id in (?)", true, ids)
      @user_recipes=@user_recipes.paginate(page: params[:page], per_page: 10)
    end
    @partners_recipes = recipes.joins(:source).where("sources.public != ?", true)
    #@recipes = []
    #@category.recipes.order("name").each do |recipe|
    #  if recipe.shareable? || current_user?(recipe.user)
    #    @recipes.push(recipe) if recipe.source.public?
    #  end
    #end
    @num_recipes=@recipes.size
    @recipes=@recipes.paginate(page: params[:page], per_page: 10)
    @partners_recipes=@partners_recipes.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        #format.html { redirect_to @category, notice: 'Category was successfully created.' }
        #format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
        #format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private
    #def signed_in_user
    #  redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #end

    #def admin_user
    #  redirect_to root_url, notice: t(:permission_denied) unless current_user.admin?
    #end

    def exist
      unless Category.where("id = ?",params[:id]).first
        redirect_to root_path
      end
    end
end
