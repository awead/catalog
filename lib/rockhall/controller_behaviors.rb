module Rockhall::ControllerBehaviors
  extend ActiveSupport::Concern

  def redirect_to_front_page
    unless !params[:q].blank? or !params[:f].blank? or !params[:search_field].blank?
      redirect_to root_path
    end
  end

  module ClassMethods
    # gets the solr name using Solrizer
    def solr_name(name, *opts)
      Solrizer.solr_name(name, *opts)
    end
  end

end