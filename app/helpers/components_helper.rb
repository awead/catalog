module ComponentsHelper


  def deprecated_parent_ead_id
    parts = params[:id].split(":")
    return parts[0]
  end

  def render_inventory
    render :partial => "components/list", :locals => { :documents => @children }
  end

  def continue_components(document)
    if @components.nil?
      next_component_button(document)
    else
      if @components.has_key?(document["ref_s"].to_sym)
        render :partial => "components/list", :locals => { :documents => @components[document["ref_s"].to_sym] }
      else
        next_component_button(document)
      end
    end
  end

  def next_component_button(document, results = String.new)
    if document["component_children_b"]
      results << link_to( image_tag("icons/button_open.png", :alt => "+ Show"),
        components_path( :parent_ref => document["ref_s"], :ead_id => document["eadid_s"] ),
        :title  => "Click to open",
        :id     => "#{document["ref_s"]}-open",
        :class  => "next_component_button")
      results << image_tag("icons/waiting.gif", :alt => "Loading...", :id => "#{document["ref_s"]}-open-waiting", :class => "hidden")
    end
    return results.html_safe
  end

  def hide_component_button
    if params["parent_ref"]
      image_tag("icons/button_close.png", :alt => "- Hide", :id => (params["parent_ref"] + "-close"), :class  => "close_component_button")
    end
  end

  def render_component_field(document, field, opts={}, results = String.new)
    #label      = opts[:label].nil? ? document[(field.to_s + "_heading_display")].first : opts[:label]
    label = "Fake"
    field_name = field + "_t" 
    unless document[field_name].nil?
      results << "<dt>" + label + ":</dt>"
      results << "<dd class=\"#{field.to_s}\">" + display_field(document[field_name]) + "</dd>"
    end
    return results.html_safe
  end

  def deprecated_render_odd_field(document)
    results = String.new
    unless document["odd_display"].nil?
      document["odd_display"].each_index do |i|
        results << "<dt>" + document["odd_display_label"][i] + ":</dt>"
        results << "<dd class=\"odd_display\">" + document["odd_display"][i] + "</dd>"
      end
    end
    return results.html_safe
  end

  def highlight?(ref)
    results = String.new
    if params[:solr_id]
      parts = params[:solr_id].split(":")
      if ref.to_s == parts.last.to_s
        results << 'style="background-color:yellow"'
      end
    end
    return results.html_safe
  end


end