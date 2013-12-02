module Rockhall::ControllerBehaviors
  extend ActiveSupport::Concern

  def redirect_to_front_page
    unless valid_parameters? or valid_controller?
      redirect_to root_path
    end
  end

  def redirect_item_to_collection
    if params[:id].match("ref")
      ead, id = params[:id].split(/ref/)
      redirect_to catalog_path([ead, "ref"+id])
    end
  end

  # Adds the solr_name method to the catalog controller
  module ClassMethods
    def solr_name(name, *opts)
      Solrizer.solr_name(name, *opts)
    end
  end

  private

  def valid_parameters?
    !params[:q].blank? or !params[:f].blank? or !params[:search_field].blank?
  end

  def valid_controller?
    self.kind_of?(BookmarksController) or self.kind_of?(AdvancedController)
  end

end