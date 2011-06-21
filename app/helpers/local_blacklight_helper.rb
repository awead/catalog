module LocalBlacklightHelper


  def application_name
    'Mockalog'
  end


  def render_document_show_field_value args
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if Blacklight.config[:linked_fields].include?(args[:field])
      render_field_link args
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
      result = [value].to_s
    end
    return result.html_safe
  end


  def field_value_separator
    '<br/>'
  end


end