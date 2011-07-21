module LocalBlacklightHelper


  # These methods override those in BlacklightHelper
  # [plugin]/app/helpers/blacklight_helper.rb

  def application_name
    'Mockalog'
  end

  def render_document_show_field_value args
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if Blacklight.config[:linked_fields].include?(args[:field])
      render_field_link args
    elsif Blacklight.config[:external_links].include?(args[:field])
      render_external_link args
    else
      render_field_value value
    end
  end

  # end of overriding methods

  # Local methods

  def render_field_link args
    result = String.new
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if value.is_a? Array
      value.each do |v|
        result << link_to(v, catalog_index_path(:search_field => args[:field].to_sym, :q => v))
        result << field_value_separator
      end
    else
      result << link_to(value, catalog_index_path(:search_field => args[:field].to_sym, :q => value))
    end
    return result.html_safe
  end

  def render_external_link args
    result = String.new
    value  = args[:value]
    text   = args[:document].get(Blacklight.config[:external_links]["resource_link_display"])
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    result << link_to(text, value.first)
    return result.html_safe
  end

  def field_value_separator
    '<br/>'
  end

  def document_icon doc
    result = String.new

    if doc.get("format").nil?
      result << image_tag("icons/component.png")
    else
      case doc.get("format")
      when "Archival Collection"
        result << image_tag("icons/collection.png")
      when "Book"
        result << image_tag("icons/book.png")
      when "Audio"
        result << image_tag("icons/audio.png")
      when "Score"
        result << image_tag("icons/score.png")
      when "Video"
        result << image_tag("icons/video.png")
      when "Periodical"
        result << image_tag("icons/periodical.png")
      when "Website"
        result << image_tag("icons/website.png")
      else
        result = doc.get("format")
      end
    end
    return result.html_safe
  end


end