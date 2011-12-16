module LocalBlacklightHelper

  include Rockhall::Innovative

  # These methods override helper methods in the Blacklight gem
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

  def link_to_document(doc, opts={:label=>Blacklight.config[:index][:show_link].to_sym, :counter => nil, :results_view => true})
    label = render_document_index_label doc, opts
    if doc["format"] == "Archival Item"
      ("<a href=\"#{catalog_path(doc.id)}##{doc["ref"]}\">" + label + "</a>").html_safe
      #link_to(label, {:controller=>"catalog", :action=>"show", :id=>doc.id, :anchor=>"asdfadf"}).html_safe
      #link_to_with_data(label, {:controller=>"catalog", :action=>"show", :id=>doc.id, :anchor=>doc["ref"]}, {:method => :put, :class => label.parameterize, :data => opts}).html_safe
    else
      link_to_with_data(label, catalog_path(doc.id), {:method => :put, :class => label.parameterize, :data => opts}).html_safe
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
    end
    return results.html_safe
  end

  def opac_link(iii_id)
    results = String.new
    link = Rockhall::Innovative.link(iii_id.first.to_s)
    results << "<h5>" + link_to("View in opac", link) + "</h5>"
    return results.html_safe
  end

end