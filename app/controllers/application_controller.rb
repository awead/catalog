class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  protect_from_forgery

  #rescue_from Exception, :with => :render_error
  #rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  #rescue_from ActionController::RoutingError, :with => :render_not_found
  #rescue_from ActionController::UnknownController, :with => :render_not_found
  #rescue_from AbstractController::ActionNotFound, :with => :render_not_found

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
