class SourcesController < ApplicationController
  before_filter :exist, only: [:show,:edit,:destroy]
  #before_filter :is_public, only: [:show]
  before_filter :signed_in_user, only: [:new,:create,:update,:edit,:detroy]
  before_filter :admin_user, only: [:new,:create,:destroy]
  before_filter :correct_user,   only: [:edit, :update]
  # GET /sources
  # GET /sources.json
  def index
    #@usersbook = Usersbook.new
    if signed_in? && current_user.admin?
      @sources = current_user.sources 
    else
      @sources = Source.public_sources
    end

    respond_to do |format|
      format.html { redirect_to new_source_path if @sources.size==0 }# index.html.erb 
      format.json { render json: @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])
    @cats=Category.from_source(@source.id).order("name")
    #@cats=[]
    #@source.recipes.each do |r|
    #  @cats.push(r.category) unless @cats.include?(r.category)
    #end
    
    #@recipes = @source.recipes.order("page ASC")
    #@recipes = @source.recipes.sort_by { |a| -(a.page.to_i) } #DESC
    @recipes = @source.recipes.sort_by { |a| (a.page.to_i) } #ASC
    unless params[:category_id].nil?
      @selcat = Category.find(params[:category_id]) 
      @recipes = @source.recipes.where("category_id = ?",@selcat.id).order("name")
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @source }
    end
  end

  # GET /sources/new
  # GET /sources/new.json
  def new
    @source = Source.new
    @source.public = true if current_user.admin?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  # POST /sources
  # POST /sources.json
  def create
    #@source = Source.new(params[:source])
    @source = current_user.sources.build(params[:source])

    respond_to do |format|
      if @source.save
        format.html { redirect_to sources_path, notice: 'Source was successfully created.' }
        #format.html { redirect_to @source, notice: 'Source was successfully created.' }
        #format.json { render json: @source, status: :created, location: @source }
      else
        format.html { render action: "new" }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.json
  def update
    #pic=params[:source][:picture]
    #File.open(Rails.root.join('app', 'assets','images', pic.original_filename), 'wb') do |file|
    #  file.write(pic.read)
    #end
    #!params.delete(:picture)

    @source = Source.find(params[:id])

    respond_to do |format|
      if @source.update_attributes(params[:source])
        format.html { redirect_to sources_path, notice: 'Source was successfully updated.' }
        #format.html { redirect_to @source, notice: 'Source was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to sources_url }
      format.json { head :no_content }
    end
  end

  private
    #def signed_in_user
    #  redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #end
    def exist
      unless Source.where("id = ?",params[:id]).first
        redirect_to root_path
      end
    end

    def is_public
      @source = Source.find(params[:id])
      unless @source.public? || current_user?(@source.user)
        redirect_to root_path, notice: t(:permission_denied) 
      end
    end

    def correct_user
      @source = Source.find(params[:id])
      unless current_user.sources.include?(@source)
        redirect_to root_path, notice: t(:permission_denied) 
      end
    end


end
