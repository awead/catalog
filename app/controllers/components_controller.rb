class ComponentsController < ApplicationController

  include Blacklight::SolrHelper
  include CatalogHelper
  
  def index
    solr_params = Hash.new
    solr_params[:fl] = "id"
    solr_params[:q]  = "parent_ref:#{params[:parent_ref]} AND _query_:\"ead_id:#{params[:ead_id]}\""
    solr_params[:qt] = "standard"
    solr_response = Blacklight.solr.find(solr_params)
    document_list = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}
    
    @documents = Array.new
    document_list.each do |doc|
      r, d = get_solr_response_for_doc_id(doc.id)
      @documents << d
    end
      
  
  end
  
  
  
end
