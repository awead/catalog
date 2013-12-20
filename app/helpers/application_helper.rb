module ApplicationHelper

  def render_constraint_text label, value
    content_tag(:i, nil, :class => "icon-remove-sign") + [label, value].compact.join(": ")
  end

  def render_index_response
    if response_has_no_search_results?
      render "zero_results"
    elsif render_grouped_response?
      render_grouped_document_index
    else
      render_document_index
    end
  end

  def render_sort_dropdown_text
    content_tag :span, :class => "primary" do
      [t("blacklight.search.sort.label", :field =>current_sort_field.label), content_tag(:b, nil, :class => "caret")].join(" ").html_safe
    end
  end

  def render_sort_options results = String.new  
    blacklight_config.sort_fields.each do |sort_key, field|
      results << content_tag(:li, link_to(field.label, url_for(params_for_search(:sort => sort_key))) )     
    end 
    return results.html_safe
  end

  def render_per_page_dropdown_text
    content_tag :span, :class => "primary" do
      [t(:'blacklight.search.per_page.button_label', :count => current_per_page), content_tag(:b, nil, :class => "caret")].join(" ").html_safe
    end
  end

  def render_per_page_options results = String.new
    blacklight_config.per_page.each do |count|
      results << content_tag(:li, link_to(count, url_for(params_for_search(:per_page => count))))
    end
    return results.html_safe
  end

  # COinS, for Zotero among others. 
  # This document_partial_name(@document) business is not quite right, but has been there for a while. 
  def render_z3988_title
    if @document.respond_to?(:export_as_openurl_ctx_kev)
      content_tag :span, nil, :class => "Z3988", :title => @document.export_as_openurl_ctx_kev(document_partial_name(@document))
    end
  end

  def document_dom_id
    "doc_" + @document.id.to_s.parameterize
  end

  def field_diplay_class solr_fname
    "blacklight-"+solr_fname.parameterize
  end

  def suggest_searching_everything
    if params[:q] and params[:search_field] and params[:search_field] != blacklight_config.default_search_field
      content_tag :li do
        t("blacklight.search.zero_results.search_fields", :search_fields => search_field_label(params))
        link_to t("blacklight.search.zero_results.search_everything"), url_for(params_for_search(:search_field=>blacklight_config.default_search_field.key))
      end
    end
  end

  def see_everything_in_collection
    if params["f"][Solrizer.solr_name("collection", :facetable)]
      content_tag :li, collection_facet_link(t("zero_results.see_collection"))
    end
  end

end
