module LocalBlacklightHelper


  def application_name
    'Mockalog'
  end

  def link_to_document(doc, opts={:label=>Blacklight.config[:index][:show_link].to_sym, :counter => nil, :results_view => true})
      label = render_document_index_label doc, opts
      if doc[:format].nil?
        vars = doc[:id].split(/:/)
        if vars[1].to_i > 1
          link_to_with_data(label, components_path({ :ead_id => doc[:ead_id], :level => doc[:component_level], :parent_ref => doc[:parent_ref] })).html_safe
        else
          link_to_with_data(label, catalog_path(vars[0], :anchor => "inventory"), {:method => :put, :class => label.parameterize, :data => opts}).html_safe
        end
      else
        link_to_with_data(label, catalog_path(doc[:id]), {:method => :put, :class => label.parameterize, :data => opts}).html_safe
      end
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