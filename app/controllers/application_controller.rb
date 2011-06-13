class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  # addresses helper problem?
  #helper :all # include all helpers, all the time
  protect_from_forgery

  before_filter :add_local_assets

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected

  def add_local_assets
      stylesheet_links << "rockhall"
      #javascript_includes << "my_js"
  end
end
