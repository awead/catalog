class ComponentsController < ApplicationController

  include Blacklight::SolrHelper
  include CatalogHelper

  def index
    solr_params = Hash.new
    solr_params[:fl]   = "id"
    if params[:component_level].to_i > 1
      solr_params[:q]    = "parent_ref:#{params[:parent_ref]} AND _query_:\"ead_id:#{params[:ead_id]}\""
    else
      solr_params[:q]    = "component_level:#{params[:component_level]} AND _query_:\"ead_id:#{params[:ead_id]}\""
    end
    solr_params[:sort] = "sort_i asc"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1000
    solr_response = Blacklight.solr.find(solr_params)
    document_list = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}

    @documents = Array.new
    document_list.each do |doc|
      r, d = get_solr_response_for_doc_id(doc.id)
      @documents << d
    end
  end

  def hide
  end


end
