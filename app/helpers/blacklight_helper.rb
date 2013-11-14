# Override methods in Blacklight::BlacklightHelperBehavior
module BlacklightHelper

  include Blacklight::BlacklightHelperBehavior

  # safe_join isn't safe enough
  def render_field_value value=nil, field_config=nil
    safe_values = Array(value).collect { |x| x.respond_to?(:force_encoding) ? x.force_encoding("UTF-8") : x }
    safe_values.join((field_config.separator if field_config) || field_value_separator).html_safe
  end

  def field_value_separator
    '<br />'
  end

  # Needed to add .html_safe on the link label
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