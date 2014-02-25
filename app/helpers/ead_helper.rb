module EadHelper

  def render_ead_html
    ead_id = @document[Solrizer.solr_name("ead", :stored_sortable)]
    render :file => "#{Rails.root}/public/fa/#{ead_id}.html"
  end

  def render_inventory_table
    render "components/list"
  end

  def render_subjects_tab_pane
    render "catalog/_show_partials/_finding_aid_partials/archival_collection_subjects"
  end

  def render_archival_item_detail
    if @component[Solrizer.solr_name("access_file", :displayable)]
      render "catalog/_show_partials/_finding_aid_partials/digital" 
    else
      render :partial => "catalog/_show_partials/_finding_aid_partials/physical", :locals => {:component => @component}  
    end
  end

  def render_parent_component_detail
    unless @component.parents.nil?
      render :partial => "catalog/_show_partials/_finding_aid_partials/physical", :locals => {:component => @component.parents.last } 
    end
  end

  def render_parent_component_title
    unless @component.parents.nil?
      content_tag :h4, render_component_title(@component.parents.last)
    end
  end

  def render_finding_aid_header
    render "catalog/_show_partials/_finding_aid_partials/header"
  end

  def is_a_finding_aid?
    ["Archival Collection", "Archival Item"].include? @document[Solrizer.solr_name("format", :displayable)].first
  end

  def component_has_children?
    @components.length > 0 unless @components.nil?
  end

  def render_show_view_for_finding_aid
    if params[:ref]  
      render "catalog/_show_partials/_finding_aid_partials/archival_item"
    else
      render "catalog/_show_partials/finding_aid"
    end
  end

  def render_full_finding_aid
    render "catalog/_show_partials/full_finding_aid"
  end

  def has_html_finding_aid?
    File.exists?(html_finding_aid)
  end

  def request_full_finding_aid?
    params.has_key? "full"
  end

  def html_finding_aid
    File.join(Rails.root, Rails.configuration.rockhall_config[:ead_path], (params[:id] + "_full.html"))
  end

  def render_collection_breadcrumb_link
    content_tag :span, :itemprop => "name" do
      link_to @document.get(Solrizer.solr_name("title", :displayable)).html_safe, 
        catalog_path(@document.id),
        :itemprop => "url"
    end
  end

  def render_parent_title_breadcrumb_link index
    content_tag :span, :itemprop => "name" do
      link_to @component[Solrizer.solr_name("parent_unittitles", :displayable)][index].html_safe, 
        catalog_path([@document.id, @component[Solrizer.solr_name("parent", :displayable)][index]]),
        :itemprop => "url"
    end
  end

  def render_component_rows
    render "components/row"
  end

  def component_row_for_index index
    params[:start] ? (index.to_i + params[:start].to_i).to_s : index
  end

  def render_component_title component = @component
    title = component.get Solrizer.solr_name("title", :displayable)
    unitdate = component.get Solrizer.solr_name("unitdate", :displayable)
    [title, unitdate].compact.join(", ").html_safe
  end

  def render_link_to_component component = @component
    link_to(render_component_title(component), archival_item_path_in_finding_aid(component))
  end

  def render_component_location component
    unless component[Solrizer.solr_name("location", :displayable)].nil?
      render :partial => "components/location", :locals => { :component => component }
    end
  end

  def ead_field_blacklisted? field
    [
      Solrizer.solr_name("title", :displayable), 
      Solrizer.solr_name("format", :displayable), 
      Solrizer.solr_name("collection", :displayable),
      Solrizer.solr_name("unitdate", :displayable)
    ].include? field
  end

  def render_show_more_components_button
    if @numfound > @components.length
      content_tag :button, t("show_more"), :id => "show_more_components", :class => "btn btn-default col-xs-12"
    end
  end

  def render_nav_link step, opts = {}
    if params[:ref]
      content_tag :li, link_to((opts[:text] ? opts[:text] : step.capitalize), catalog_path(params[:id], :anchor => step))
    else
      content_tag :li, link_to((opts[:text] ? opts[:text] : step.capitalize), "#"+step, :data => { :toggle => "tab"}), :class => opts[:class]
    end
  end

  def archival_item_path_in_finding_aid document = @document
    ref = document.get Solrizer.solr_name("ref", :stored_sortable)
    ead = document.get Solrizer.solr_name("ead", :stored_sortable)
    catalog_path([ead, ref])
  end

  # Remove in Bootstrap 3
  def breadcrumb_divider
    "/"
  end

  def collection_has_inventory?
    @document.get Solrizer.solr_name("inventory", :type => :boolean)
  end

  def collection_facet_link text, terms = params["f"][Solrizer.solr_name("collection", :facetable)]
    terms_array = terms.is_a?(Array) ? terms : [terms]
    link_to text, { "f" => { Solrizer.solr_name("collection", :facetable) => terms_array } }
  end

  def material_facet_link component
    value = component.get Solrizer.solr_name("material", :displayable)
    unless value.nil?
      link_to value, { "f" => { Solrizer.solr_name("material", :facetable) => value } }
    end
  end

  def render_digital_label component
    if component[Solrizer.solr_name("access_file", :displayable)]
      content_tag :span, "Online", :class => "label label-default"
    end
  end

end
