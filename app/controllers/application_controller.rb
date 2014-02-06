class ApplicationController < ActionController::Base

  include Blacklight::Controller

  layout "catalog"

  protect_from_forgery

  unless Rails.env.match("development")
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from AbstractController::ActionNotFound, :with => :render_not_found
  end

  private

  def render_not_found(exception)
    logger.error(exception)
    flash[:notice] = "The requested resource was not found"
    redirect_to root_path
  end

  def render_error(exception)
    logger.error(exception)
    flash[:notice] = "Resource id #{params[:id]} was not found or is unavailable"
    redirect_to root_path
  end

end
