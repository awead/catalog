module EadHelper

  def render_ead_html
    ead_id = @document[Solrizer.solr_name("ead", :stored_sortable)]
    render :file => "#{Rails.root}/public/fa/#{ead_id}.html"
  end

  def render_inventory_table
    render "components/list"
  end

  def render_subjects_tab_pane
    render "catalog/_show_partials/archival_collection_subjects"
  end

  def is_a_finding_aid?
    ["Archival Collection", "Archival Item"].include? @document[Solrizer.solr_name("format", :displayable)].first
  end

  def has_json?
    File.exists?(File.join(Rails.root, "public", "fa", (@document["ead_id"] + "_toc.json"))) unless @document["ead_id"].nil?
  end

  def component_has_children?
    @component.get Solrizer.solr_name("component_children", :type => :boolean)
  end

  def render_show_view_for_finding_aid
    if params[:ref]
      render "catalog/_show_partials/component"
    else
      render "catalog/_show_partials/finding_aid"
    end
  end

  def render_parent_title_breadcrumb_link index
    link_to @component[Solrizer.solr_name("parent_unittitles", :displayable)][index].html_safe, 
      catalog_path([@document.id, @component[Solrizer.solr_name("parent", :displayable)][index]])
  end

  def render_component_rows
    render "components/row"
  end

  def component_row_for_index index
    params[:start] ? (index.to_i + params[:start].to_i).to_s : index
  end

  def render_component_title component
    title = component.get Solrizer.solr_name("title", :displayable)
    unitdate = component.get Solrizer.solr_name("unitdate", :displayable)
    ref = component.get Solrizer.solr_name("ref", :stored_sortable)
    if unitdate.nil?
      link_to(title.html_safe, catalog_path([params[:id], ref]))
    else
      link_to([title, unitdate].join(", ").html_safe, catalog_path([params[:id], ref]))
    end
  end

  def render_component_location component
    render_document_show_field_value(component, :field => Solrizer.solr_name("location", :displayable))
  end

  def ead_field_blacklisted? field
    [Solrizer.solr_name("title", :displayable), Solrizer.solr_name("format", :displayable)].include? field
  end

  def render_show_more_components_button
    if @numfound > @components.length
      content_tag :div, :class => "row-fluid" do
        content_tag :button, "more", :id => "show_more_components", :class => "btn span12"
      end
    end
  end

  def render_nav_link step, opts = {}
    if params[:ref]
      content_tag :li, link_to(step.capitalize, catalog_path(params[:id], :anchor => step))
    else
      content_tag :li, link_to(step.capitalize, "#"+step, :data => { :toggle => "tab"}), :class => opts[:class]
    end
  end

end