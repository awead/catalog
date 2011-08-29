class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  helper :all # include all helpers, all the time
  protect_from_forgery

  before_filter :add_local_assets

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected

  def add_local_assets
    #stylesheet_links[0].delete("blacklight/blacklight")
    #stylesheet_links[0].delete("yui")
    #stylesheet_links[0].delete("mediaall")
    #stylesheet_links[0].delete("jquery/ui-lightness/jquery-ui-1.8.1.custom.css")
    #stylesheet_links << "yui-2.9.0"
    stylesheet_links << "rockhall"
    javascript_includes << "rockhall/rockhall.js"
    logger.info("Stylesheets: #{stylesheet_links.join(" - ")}")
  end

end
