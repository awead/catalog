class ApplicationController < ActionController::Base

  include Blacklight::Controller

  layout "catalog"

  protect_from_forgery

  if Rails.env.match?("production")
    rescue_from Exception, :with => :render_error
    rescue_from NameError, :with => :render_error
    rescue_from RuntimeError, :with => :render_error
    rescue_from ActionView::Template::Error, :with => :render_error
    rescue_from ActiveRecord::StatementInvalid, :with => :render_error
    rescue_from RSolr::Error::Http, :with => :render_error
    rescue_from Blacklight::Exceptions::ECONNREFUSED, :with => :render_error
    rescue_from Errno::ECONNREFUSED, :with => :render_error
    rescue_from ActionDispatch::Cookies::CookieOverflow, :with => :render_error
    rescue_from AbstractController::ActionNotFound, :with => :render_not_found
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from Blacklight::Exceptions::InvalidSolrID, :with => :render_not_found
  end

  private

  def render_not_found exception
    logger.error("Rendering 404 page due to exception: #{exception.inspect} - #{exception.backtrace if exception.respond_to? :backtrace}")
    render :template => '/error/404', :layout => "error", :formats => [:html], :status => 404
  end

  def render_error exception
    logger.error("Rendering 500 page due to exception: #{exception.inspect} - #{exception.backtrace if exception.respond_to? :backtrace}")
    render :template => '/error/500', :layout => "error", :formats => [:html], :status => 500
  end

end
