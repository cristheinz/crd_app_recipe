class IngredientsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user#, only: [:index,:show,:edit,:update,:destroy]
  skip_before_filter :signed_in_user, only: [:show, :index]
  skip_before_filter :admin_user, only: [:show, :index]
  # GET /ingredients
  # GET /ingredients.json
  def index
    #@ingredients = Ingredient.all
    #@ingredients = Ingredient.order("name ASC")
    @ingredients = Ingredient.order("name ASC").where("name like ?", params[:initial] ? "#{params[:initial]}%" : "A%")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ingredients }
    end
  end

  # GET /ingredients/1
  # GET /ingredients/1.json
  def show
    @ingredient = Ingredient.find(params[:id])
    begin
      @txt= "<a href=\"http://pt.wikipedia.org/wiki/#{@ingredient.name}\" target=\"_blank\">wiki</a>"
      
      image=Google::Search::Image.new(:query => "#{@ingredient.name}").first
      #txt=Google::Search::Item::Web.new(:query => "#{@ingredient.name}").first
      @link= image.uri
      #@txt= txt.to_s
      rescue
        @link=no_image_url
        #@txt= "<a href=\"http://pt.wikipedia.org/wiki/#{@ingredient.name}\" target=\"_blank\">wiki</a>"
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ingredient }
    end
  end

  # GET /ingredients/new
  # GET /ingredients/new.json
  def new
    @ingredient = Ingredient.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ingredient }
    end
  end

  # GET /ingredients/1/edit
  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  # POST /ingredients
  # POST /ingredients.json
  def create
    @ingredient = Ingredient.new(params[:ingredient])

    respond_to do |format|
      if @ingredient.save
        format.html { redirect_to @ingredient, notice: 'Ingredient was successfully created.' }
        format.json { render json: @ingredient, status: :created, location: @ingredient }
      else
        format.html { render action: "new" }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ingredients/1
  # PUT /ingredients/1.json
  def update
    @ingredient = Ingredient.find(params[:id])

    respond_to do |format|
      if @ingredient.update_attributes(params[:ingredient])
        format.html { redirect_to @ingredient, notice: 'Ingredient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.json
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to ingredients_url }
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

end
