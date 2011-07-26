module LocalBlacklightHelper


  # These methods override those in BlacklightHelper
  # [plugin]/app/helpers/blacklight_helper.rb

  def application_name
    'Mockalog'
  end

  def render_document_show_field_value args
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if Blacklight.config[:linked_fields].keys.include?(args[:field].to_sym)
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
    search = Blacklight.config[:linked_fields][args[:field].to_sym]
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if value.is_a? Array
      value.each do |v|
        result << link_to(v, catalog_index_path( :search_field => search, :q => "\"#{v}\"" ))
        result << field_value_separator
      end
    else
      result << link_to(value, catalog_index_path( :search_field => search, :q => "\"#{v}\"" ))
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
      result << image_tag("icons/unknown.png")
    else
      filename = doc.get("format").downcase.gsub(/\s/,"_")
      result << image_tag("icons/#{filename}.png")
    end
    return result.html_safe
  end


end