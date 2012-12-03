module Rockhall::EadSolrMethods

  # Returns the content from a solr field of a given document.
  #
  # Required inputs: String:field, String:id
  # Where *field* is the name of the solr field and *id* is the solr document id.
  def get_field_from_solr(field, id)
    result = Blacklight.solr.find( {:q => 'id:"'+id+'"', :qt => 'document', :fl => field, :rows => 1 } )
    result["response"]["docs"].empty? ? nil : result["response"]["docs"].first[field.to_sym]
  end

  # Retrieves ead component documents given different requirements.  The results are always returned
  # as a array of strings, each corresponding to the solr document id for an ead component document.
  #
  # Required: String:eadid
  # Where *eadid* is the ead id of the document such as ARC-0005.
  #
  # Options:
  #  - String:level
  #  - String:parent_id_s
  #
  # Examples:
  #     get_component_docs_from_solr("ARC-0004", {:level => "1"})
  # Returns an array of all the first-level component ids for ARC-0004
  #     get_component_docs_from_solr("ARC-0004", {:parent_id_s => "ref45"})
  # Returns an array of all the component ids that have ref45 as their parent
  def get_component_docs_from_solr(eadid, opts={}, results = Array.new, solr_params = Hash.new)
    solr_params[:fl]   = "id"
    if opts[:parent_id_s]
      solr_params[:q]    = 'parent_id_s:"'+opts[:parent_id_s]+'" AND _query_:"eadid_s:'+eadid+'"'
    else
      solr_params[:q]    = 'component_level_i:'+opts[:level]+' AND _query_:"eadid_s:'+eadid+'"'
    end
    solr_params[:sort] = "sort_i asc"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 10000
    Blacklight.solr.find(solr_params).docs.each do |doc|
      results << doc["id"]
    end
    return results
  end


end
