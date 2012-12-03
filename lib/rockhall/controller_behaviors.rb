module Rockhall::ControllerBehaviors

  # Determine if item has child components
  #
  # This only aplies to ead and not to marc or other metdata formats. For now, the 
  # determining factor is the presence of "ref" in the id.  The alternative method,
  # which is commented-out at the moment, is to query solr for the ref_s field.
  def query_child_components solr_params = Hash.new

    # Alternative solr query method
    #solr_params[:fl]   = "eadid_s, ref_s"
    #solr_params[:q]    = "id:#{params[:id]}"
    #solr_params[:qt]   = "document"
    #solr_params[:rows] = 1
    #solr_response = Blacklight.solr.find(solr_params)
    #unless solr_response.docs.empty?
      #@children = additional_ead_components(solr_response.docs.first[:eadid_s],solr_response.docs.first[:ref_s])
    #end

    # Just check the id
    id, ref_num = params[:id].split(/ref/)
    unless ref_num.nil?
      @children = additional_ead_components(id,("ref"+ref_num))
    end
  end

  # Query solr for additional ead components that are attached to a given ead document
  def additional_ead_components(id,ref, solr_params = Hash.new)
    solr_params[:fl]   = "id"
    solr_params[:q]    = "parent_id_s:#{ref} AND eadid_s:#{id}"
    solr_params[:sort] = "sort_i asc"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 10000
    solr_response = Blacklight.solr.find(solr_params)
    list = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}

    docs = Array.new
    list.each do |doc|
      r, d = get_solr_response_for_doc_id(doc.id)
      docs << d
    end
    return docs
  end

  # Renders the ead xml file.  This is the same file that we use for indexing the ead as well.
  def ead_xml
    file = File.join(Rails.root, Rails.configuration.rockhall_config[:ead_path], (params[:id] + ".xml"))
    if File.exists?(file)
      render :file => file 
    else
      flash[:notice] = "XML file for #{params[:id]} was not found or is unavailable"
      redirect_to root_path
    end
  end

end