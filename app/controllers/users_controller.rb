class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index,:show, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:show, :edit, :update, :destroy]
  before_filter :admin_user, only: [:index]
  before_filter :unsigned, only: [:new]

  def index
    @users = User.all
  end

  def show
    #@user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @source = @user.sources.build(name: @user.id, publish_date: @user.created_at, public: "f", image: "")
      if @source.save
        UserMailer.welcome_email(@user).deliver
        sign_in @user
        flash[:success] = t(:welcome_notice)
        #redirect_to root_path# if @user.admin?
        redirect_to welcome_path
      else
        render 'new'
      end  
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = t(:profile_updated)
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    user=User.find(params[:id])
    user.destroy
    flash[:success] = t(:account_destroyed)
     
    if !current_user.admin? || current_user?(user)
      sign_out
      redirect_to root_path
    else
      redirect_to users_path
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || current_user.admin?
        redirect_to(root_path) 
      end
    end
    
    def unsigned
      if signed_in?
        redirect_to(root_path)
      end
    end
end
