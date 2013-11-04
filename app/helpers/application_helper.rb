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
      [t('blacklight.search.sort.label', :field =>current_sort_field.label), content_tag(:b, nil, :class => "caret")].join(" ").html_safe
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
    content_tag :span, nil, :class => "Z3988", :title => @document.export_as_openurl_ctx_kev(document_partial_name(@document))
  end

  def document_dom_id
    "doc_" + @document.id.to_s.parameterize
  end

end
