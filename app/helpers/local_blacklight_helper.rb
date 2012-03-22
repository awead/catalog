module LocalBlacklightHelper

  include Rockhall::Innovative

  # These methods override helper methods in the Blacklight gem
  def application_name
    'Rock and Roll Hall of Fame and Museum | Library and Archives | Catalog'
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

  # overrides app/helpers/blacklight/blacklight_helper_behavior.rb
  def render_document_heading
    render :partial => "catalog/rockhall_heading"
  end

  # end of overriding methods

  # Local methods

  def render_field_link args
    result = String.new
    search = Blacklight.config[:linked_fields][args[:field].to_sym][:search]
    facet  = Blacklight.config[:linked_fields][args[:field].to_sym][:facet]
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if value.is_a? Array
      value.each do |v|
        if facet
          result << link_to(v, add_facet_params_and_redirect(facet, v), :class=>"facet_select label")
          result << "<br/>"
        else
          result << link_to(v, catalog_index_path( :search_field => search, :q => "\"#{v}\"" ))
          result << field_value_separator
        end
      end
    else
      if facet
        result << link_to(v, add_facet_params_and_redirect(facet, v), :class=>"facet_select label")
      else
        result << link_to(value, catalog_index_path( :search_field => search, :q => "\"#{v}\"" ))
      end
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

  def check_availability(iii_id)
    results = String.new
    status = Rockhall::Innovative.get_holdings(iii_id.first.to_s)
    if status.first
      results << "<h3>Holdings</h3>"
      results << "<table>"
      results << "<tr><th>Location</th><th>Call Number</th><th>Availability</th></tr>"
      status.each do |s|
        results << "<tr><td>" + s.to_s + "</td></tr>"
      end
      results << "</table>"
    else
      results << "<h3>Holdings</h3>"
      results << "Unavailable"
    end
    return results.html_safe
  end

  def opac_link(iii_id)
    # TODO: BL-136: change this to a 'Check nearby libraries' link to Worldcat
    results = String.new
    link = Rockhall::Innovative.link(iii_id.first.to_s)
    results << "<h5>" + link_to("View in opac", link) + "</h5>"
    return nil
  end

end