module MarcHelper

  def document_heading
    @document[blacklight_config.show.heading] || @document.id
  end

  def render_external_link args, results = Array.new
    begin
      value = args[:document][args[:field]]
      if value.length > 1
        value.each_index do |index|
          text      = args[:document][blacklight_config.show_fields[args[:field]][:text]][index]
          url       = value[index]
          link_text = text.nil? ? url : text
          results << link_to(link_text, url, { :target => "_blank" }).html_safe
        end
      else
        text      = args[:document].get(blacklight_config.show_fields[args[:field]][:text])
        url       = args[:document].get(args[:field])
        link_text = text.nil? ? url : text
        results << link_to(link_text, url, { :target => "_blank" }).html_safe
      end
    rescue
      return nil
    end
    return results.join(field_value_separator).html_safe
  end

  def render_facet_link args, results = Array.new
    begin
      value = args[:document][args[:field]]
      if value.is_a? Array
        value.each do |text|
          results << facet_link(text, blacklight_config.show_fields[args[:field]][:facet])
        end
      else
        results << facet_link(value, blacklight_config.show_fields[args[:field]][:facet])
      end
    rescue
      return nil
    end
    return results.join(field_value_separator).html_safe
  end

  # Renders a link for a given term and facet.  The content of term is used for the 
  # text of the link and facet is the solr field to facet on.
  def facet_link term, facet
    link_to(term, 
            add_facet_params_and_redirect(facet, remove_highlighting(term)), 
            :class=>"facet_select label")
  end

  def remove_highlighting text
    text.gsub(/<\/span>/,"").gsub(/<span.+>/,"")
  end

  def render_search_link args, results = Array.new
    args[:document][args[:field]].each do |text|
      results << link_to(text, catalog_index_path( :search_field => "all_fields", :q => "\"#{text}\"" ))
    end
    return results.join(field_value_separator).html_safe
  end

  # Presently not used because this is accomplished with SolrMarc at index time using a custom
  # method in a beanshell script.  However, I'm leaving this here in case I change my mind and want
  # it redendered by Rails instead.
  def render_call_number args, results = Array.new
    locations = ["rx", "rhlrr", "rharr", "rhs2", "rhs2o", "rhs3"]
    if args[:document]["marc_display"]
      MARC::XMLReader.new(StringIO.new(args[:document]["marc_display"])).first.find_all {|f| f.tag == '945'}.each do |field|
        results << field['a'] if locations.include?(field['l'].strip)
      end
    end
    return results.join(field_value_separator).html_safe
  end

  def field_value_separator
    '<br/>'
  end

  def document_icon doc, result = String.new
    if doc.get("format").nil?
      result << image_tag("icons/unknown.png")
    else
      filename = doc.get("format").downcase.gsub(/\s/,"_")
      result << image_tag("icons/#{filename}.png")
    end
    return result.html_safe
  end

end