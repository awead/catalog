module Rockhall::SolrHelperExtension
  extend ActiveSupport::Concern
  include Blacklight::SolrHelper

  # overide Blacklight::SolrHelper.get_solr_response_for_doc_id to include the current
  # search query for highlighting in the #show view.
  def get_solr_response_for_doc_id(id=nil, extra_controller_params={})
    unless @current_search_session.nil?
      extra_controller_params["hl.q".to_sym] ||= []
      extra_controller_params["hl.q".to_sym] << @current_search_session.query_params[:q]
    end  
    super
  end

  def get_ead_component
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

  def get_children_for_component
    if params[:id].match(/^ARC/) or params[:id].match(/^RG/)
      if params[:ref]
        @numfound, @components = ead_components_from_parent(params[:id], params[:ref]) unless is_hydra_ref?(params[:ref])
      else
        @numfound, @components = first_level_ead_components(params[:id])
      end
    end
  end

  # Queries the current solr document for any first-level components, returning either an array of the 
  # documents or nil.
  # 
  # Required: id
  # Options:
  #  - start: If you want the results to start on a specific row; defaults to 0
  #  - rows:  Number of rows to return; defaults to "all" or 10,000
  def first_level_ead_components id, opts={}, docs = Array.new
    solr_response = Blacklight.solr.get "select", :params => first_level_solr_query(id,opts)
    return number_found_from_solr_response(solr_response), docs_from_solr_response(solr_response)
  end

  # Returns the content from a solr field of a given document.
  #
  # Required inputs: String:field, String:id
  # Where *field* is the name of the solr field and *id* is the solr document id.
  def get_field_from_solr id, field
    result = Blacklight.solr.get "select", :params => {:q => 'id:"'+id+'"', :qt => 'document', :fl => field, :rows => 1 }
    result["response"]["docs"].empty? ? nil : result["response"]["docs"].first[field]
  end


  # Query solr for additional ead components that are attached to a given ead document
  #
  # Required:
  #  - id:  The id of the finding aid, ead_id, ex. ARC-0037
  #  - ref: The ref id of the parent component, ref_id, ex. ref1
  # Options: sams as .first_level_ead_components
  def ead_components_from_parent id, ref, opts={}
    solr_response = Blacklight.solr.get "select", :params => additional_solr_query(id,ref,opts)
    return [number_found_from_solr_response(solr_response), docs_from_solr_response(solr_response)]
  end

  # Components imported from Hydra need to have aditional fields added to the their solr documents.
  def add_additional_fields_to_hydra_component
    if is_hydra_ref?(params[:ref])
      result = Blacklight.solr.get "select", :params => additional_fields_query
      @component.merge!(result["response"]["docs"].first) { |key, oldval, newval| (newval + oldval).uniq }
    end
  end

  private

  def first_level_solr_query id, opts={}, solr_params = Hash.new
    solr_params[:fl]    = "id"
    solr_params[:q]     = Solrizer.solr_name("component_level", :type => :integer)+':1 AND _query_:"'+Solrizer.solr_name("ead", :stored_sortable)+':'+id+'"'
    solr_params[:sort]  = component_sort_fields.join(", ")
    solr_params[:qt]    = "standard"
    solr_params[:rows]  = opts[:rows]  ? opts[:rows]  : Rails.configuration.rockhall_config[:max_components]
    solr_params[:start] = opts[:start] ? opts[:start] : 0
    return solr_params
  end

  def additional_solr_query id, ref, opts={}, solr_params = Hash.new
    solr_params[:fl]    = "id"
    solr_params[:q]     = Solrizer.solr_name("parent", :stored_sortable)+":#{ref} AND "+Solrizer.solr_name("ead", :stored_sortable)+":#{id}"
    solr_params[:sort]  = component_sort_fields.join(", ")
    solr_params[:qt]    = "standard"
    solr_params[:rows]  = opts[:rows]  ? opts[:rows]  : Rails.configuration.rockhall_config[:max_components]
    solr_params[:start] = opts[:start] ? opts[:start] : 0
    return solr_params
  end

  def component_sort_fields
    [
      Solrizer.solr_name("sort", :sortable, :type => :integer) + " asc", 
      Solrizer.solr_name("title", :sortable) + " asc"
    ]
  end

  def additional_fields_query solr_params = Hash.new
    solr_params[:fl]    = [Solrizer.solr_name("parent_unittitles", :displayable), Solrizer.solr_name("parent", :displayable)]
    solr_params[:q]     = 'id:"' + hydra_component_parent_id + '"'
    solr_params[:qt]    = "document"
    return solr_params
  end

  def docs_from_solr_response solr_response, docs = Array.new
    solr_response["response"]["docs"].collect {|r| r["id"]}.each do |id|
      r, d = get_solr_response_for_doc_id(id)
      docs << d
    end
    return docs
  end

  def number_found_from_solr_response solr_response
    solr_response["response"]["numFound"]
  end

  def is_hydra_ref? ref
    ref.match(/^rrhof/) 
  end

  def hydra_component_parent_id
    [@component.get(Solrizer.solr_name("ead", :stored_sortable)), @component.get(Solrizer.solr_name("parent", :stored_sortable))].join
  end

end