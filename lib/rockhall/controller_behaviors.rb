module Rockhall::ControllerBehaviors
  extend ActiveSupport::Concern

  def redirect_to_front_page
    unless valid_parameters? or valid_controller?
      redirect_to root_path
    end
  end

  def show_item_within_collection
    ead, id = get_collection_from_item
    redirect_to catalog_path([ead, id]) unless ead.nil?
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

  def get_collection_from_item
    if params[:id].match("ref")
      ead, id = params[:id].split(/ref/)
      return ead, "ref"+id
    elsif params[:id].match("rrhof")
      ead = get_field_from_solr params[:id], Solrizer.solr_name("ead", :stored_sortable)
      return ead, params[:id]
    end
  end

end