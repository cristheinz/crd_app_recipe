class ApplicationController < ActionController::Base
  before_filter :set_locale
  protect_from_forgery
  include SessionsHelper
  include AssignmentsHelper
  include ShoppinglistHelper
  
  def set_locale
    #I18n.locale = params[:locale] || I18n.default_locale
    if params[:locale] && ["pt","en"].include?(params[:locale])
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options={})
  	logger.debug "default_url_options is passed options: #{options.inspect}\n"
  	{ :locale => I18n.locale }
  end
end
