module Rockhall::SolrHelperExtension
  extend ActiveSupport::Concern
  include Blacklight::SolrHelper


  # Determine if item has child components
  #
  # This only aplies to ead and not to marc or other metdata formats. For now, the 
  # determining factor is the kind of id, whethere it begings with ARC, RG or has ref
  # in it, indicating that it's an archival item..  The alternative method,
  # which is commented-out at the moment, is to query solr for the ref_id field.
  def query_ead_components solr_params = Hash.new

    @children = Array.new
    @parents  = Hash.new

    # Alternative solr query method
    #solr_params[:fl]   = "ead_id, ref_id"
    #solr_params[:q]    = "id:#{params[:id]}"
    #solr_params[:qt]   = "document"
    #solr_params[:rows] = 1
    #solr_response = Blacklight.solr.get "select", :params => solr_params
    #unless solr_response.docs.empty?
      #@children = additional_ead_components(solr_response.docs.first[:ead_id],solr_response.docs.first[:ref_id])
    #end

    # Just check the id
    if params[:id].match(/^ARC/) or params[:id].match(/^RG/) 
      @children = first_level_ead_components(params[:id])
    end
    if params[:ref]
      refs = get_field_from_solr((params[:id] + params[:ref]), Solrizer.solr_name("parent", :displayable))
      unless refs.nil?
        refs.each do |ref|
          @parents[ref] = additional_ead_components(params[:id], ref)
        end
      end
    end
    return @children, @parents
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
    return docs_from_solr_response solr_response
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
  def additional_ead_components id, ref, opts={}
    solr_response = Blacklight.solr.get "select", :params => additional_solr_query(id,ref,opts)
    return docs_from_solr_response solr_response
  end

  private

  def first_level_solr_query id, opts={}, solr_params = Hash.new
    solr_params[:fl]    = "id"
    solr_params[:q]     = Solrizer.solr_name("component_level", :type => :integer)+':1 AND _query_:"'+Solrizer.solr_name("ead", :stored_sortable)+':'+id+'"'
    solr_params[:sort]  = Solrizer.solr_name("sort", :sortable, :type => :integer)+" asc"
    solr_params[:qt]    = "standard"
    solr_params[:rows]  = opts[:rows]  ? opts[:rows]  : 10000
    solr_params[:start] = opts[:start] ? opts[:start] : 0
    return solr_params
  end

  def additional_solr_query id, ref, opts={}, solr_params = Hash.new
    solr_params[:fl]    = "id"
    solr_params[:q]     = Solrizer.solr_name("parent", :stored_sortable)+":#{ref} AND "+Solrizer.solr_name("ead", :stored_sortable)+":#{id}"
    solr_params[:sort]  = Solrizer.solr_name("sort", :sortable, :type => :integer)+" asc"
    solr_params[:qt]    = "standard"
    solr_params[:rows]  = opts[:rows]  ? opts[:rows]  : 10000
    solr_params[:start] = opts[:start] ? opts[:start] : 0
    return solr_params
  end

  def docs_from_solr_response solr_response, docs = Array.new
    solr_response["response"]["docs"].collect {|r| r["id"]}.each do |id|
      r, d = get_solr_response_for_doc_id(id)
      docs << d
    end
    return docs
  end

end