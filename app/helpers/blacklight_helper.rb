# Override methods in Blacklight::BlacklightHelperBehavior
module BlacklightHelper

  include Blacklight::BlacklightHelperBehavior

  # This replaces Blacklight::BlacklightHelperBehavior.link_to_document to
  # render a link to an archival item.  The behavior for all other formats
  # is the same
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    label ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts

    if doc["format"] == "Archival Item"
      id, refnum = doc["id"].split("ref")
      link_to label, catalog_path([id,"ref"+refnum]), { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
    else
      link_to label, doc, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
    end
  end

  # safe_join isn't safe enough
  def render_field_value value=nil, field_config=nil
    safe_values = Array(value).collect { |x| x.respond_to?(:force_encoding) ? x.force_encoding("UTF-8") : x }
    safe_values.join((field_config.separator if field_config) || field_value_separator).html_safe
  end

  def field_value_separator
    '<br />'
  end

  def link_back_to_catalog(opts={:label=>nil})
    query_params = current_search_session.try(:query_params) || {}
    link_url = url_for(query_params)
    if link_url =~ /bookmarks/
      opts[:label] ||= t('blacklight.back_to_bookmarks')
    end

    opts[:label] ||= t('blacklight.back_to_search')

    link_to opts[:label].html_safe, link_url
  end

  # Override to call first because our heading field is mutlivalued
  def document_heading document=nil
    document ||= @document
    document[blacklight_config.show.heading].first.html_safe || document.id
  end

end