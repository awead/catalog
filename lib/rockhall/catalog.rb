module Rockhall::Catalog
  extend ActiveSupport::Concern

  include Blacklight::Catalog
  include Rockhall::SolrHelper
  include Rockhall::Solr::ComponentQueries

  # Adds the solr_name method to the catalog controller
  module ClassMethods
    def solr_name(name, *opts)
      Solrizer.solr_name(name, *opts)
    end
  end

  def redirect_to_front_page
    unless valid_parameters? or valid_controller?
      redirect_to root_path
    end
  end

  def show_item_within_collection
    ead, id = get_collection_from_item
    redirect_to catalog_path([ead, id]) unless ead.nil?
  end

  def get_component
    if params[:id].match(/^ARC/) or params[:id].match(/^RG/) and params[:ref]
      if is_hydra_ref?(params[:ref])
        not_used, @component = get_solr_response_for_doc_id(params[:ref]) 
        add_additional_fields_to_hydra_component
      else
        not_used, @component = get_solr_response_for_doc_id(params[:id]+params[:ref])
      end
    end
    return @component
  end

  def get_component_children
    if params[:id].match(/^ARC/) or params[:id].match(/^RG/)
      if params[:ref]
        @numfound, @components = ead_components_from_parent(params[:id], params[:ref]) unless is_hydra_ref?(params[:ref])
      else
        @numfound, @components = first_level_ead_components(params[:id])
      end
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

  def is_hydra_ref? ref
    ref.match(/^rrhof/) 
  end

end
