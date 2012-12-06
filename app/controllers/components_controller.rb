class ComponentsController < ApplicationController

  include Rockhall::EadSolrMethods

  # Remove these if everything still works:
  #include Blacklight::SolrHelper
  #include CatalogHelper
  #include Blacklight::Configurable
  #copy_blacklight_config_from(CatalogController)

  def index
    @documents = get_component_docs_from_solr(params[:ead_id], { :parent_ref => params[:parent_ref] })
  end

end