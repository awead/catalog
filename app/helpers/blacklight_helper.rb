# Override methods in Blacklight::BlacklightHelperBehavior
module BlacklightHelper

  include Blacklight::BlacklightHelperBehavior

  # safe_join isn't safe enough
  def render_field_value value=nil, field_config=nil
    safe_values = Array(value).collect { |x| x.respond_to?(:force_encoding) ? x.force_encoding("UTF-8") : x }
    if field_config && field_config.itemprop
      render_schema_property safe_values, field_config.itemprop
    else
      safe_values.join((field_config.separator if field_config) || field_value_separator).html_safe
    end
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
    document[blacklight_config.show.title_field].nil? ? document.id : document[blacklight_config.show.title_field].first.html_safe
  end

  # Override to:
  #  * pass field_config on to our helper methods
  #  * add additional logic to determine field highlighting
  #
  # TODO: Currently not tested; needs refactoring.
  def get_field_values document, field, field_config, options = {}
    case
      when (field_config and field_config.helper_method)
        send(field_config.helper_method, options.merge(:document => document, :field => field, :field_config => field_config))
      when (field_config and field_config.link_to_search)
        link_field = if field_config.link_to_search === true
          field_config.field
        else
          field_config.link_to_search
        end
        Array(document.get(field, :sep => nil)).map do |v|
          link_to render_field_value(v, field_config), search_action_url(add_facet_params(link_field, v, {}))
        end if field
      when (field_config and field_config.highlight and document.has_highlight_field?(field_config.field))
        document.highlight_field(field_config.field).map { |x| x.html_safe } if document.has_highlight_field? field_config.field
      else
        document.get(field, :sep => nil) if field
    end
  end

  # Render the document index heading
  # Override to highlight seach results in the heading
  def render_document_index_label doc, opts = {}
    label = nil
    label ||= doc.highlight_field(opts[:label]) if opts[:label].instance_of?(Symbol) && doc.has_highlight_field?(opts[:label])
    label ||= doc.get(opts[:label], :sep => nil) if opts[:label].instance_of? Symbol
    label ||= opts[:label].call(doc, opts) if opts[:label].instance_of? Proc
    label ||= opts[:label] if opts[:label].is_a? String
    label ||= doc.id
    render_field_value label
  end

end
