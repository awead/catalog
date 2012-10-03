module LocalBlacklightHelper

  #
  # These methods override helper methods in the Blacklight gem
  #

  def application_name
    'Rock and Roll Hall of Fame and Museum | Library and Archives | Catalog'
  end

  # overrides app/helpers/blacklight/blacklight_helper_behavior.rb
  def render_document_heading
    render :partial => "catalog/rockhall_heading"
  end

  # overrides link_to_document to method to directly display the archival item within
  # the finding aid.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    label ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts
    if doc[:format] == "Archival Item"
      url = catalog_path(doc.id) + "#" + doc.id.to_s
      link_to label, url
    else
      link_to label, doc, :'data-counter' => opts[:counter]
    end
  end

  #
  # end of overriding methods
  #

  def render_external_link args
    text      = args[:document].get(blacklight_config.show_fields[args[:field]][:text])
    url       = args[:document].get(args[:field])
    link_text = text.nil? ? url : text
    link_to(link_text, url, { :target => "_blank" }).html_safe
  end

  def render_facet_link args, results = Array.new
    value = args[:document][args[:field]]
    if value.is_a? Array
      value.each do |text|
        results << link_to(text, add_facet_params_and_redirect(blacklight_config.show_fields[args[:field]][:facet], text), :class=>"facet_select label")
      end
    else
      results << link_to(value, add_facet_params_and_redirect(blacklight_config.show_fields[args[:field]][:facet], value), :class=>"facet_select label")
    end
    return results.join(field_value_separator).html_safe
  end

  def render_search_link args, results = Array.new
    args[:document][args[:field]].each do |text|
      results << link_to(text, catalog_index_path( :search_field => "all_fields", :q => "\"#{text}\"" ))
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