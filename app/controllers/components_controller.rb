class ComponentsController < ApplicationController

  include Blacklight::SolrHelper
  include CatalogHelper
  include Rockhall::EadSolrMethods

  include Blacklight::Configurable
  copy_blacklight_config_from(CatalogController)

  def index
    @documents = get_component_docs_from_solr(params[:ead_id], { :level => params[:component_level], :parent_ref => params[:parent_ref] })
  end

  def hide
  end


end
