module ComponentsHelper


  def parent_ead_id
    parts = params[:id].split(":")
    return parts[0]
  end

  def continue_components(document)
    if @components.nil?
      next_component_button(document)
    else
      if @components.has_key?(document[:ref].to_sym)
        render :partial => "components/show", :locals => { :documents => @components[document[:ref].to_sym] }
      else
        next_component_button(document)
      end
    end
  end

  def next_component_button(document)
    results = String.new
    if document["component_children_b"]
      level = document[:component_level].to_i + 1
      results << link_to( image_tag("icons/button_open.png", :alt => "+ Show"),
        components_path( :parent_ref => document[:ref], :ead_id => document[:ead_id], :component_level => level ),
        :id => "#{document[:ref]}-switch",
        :remote => true,
        :onclick => "showWaiting('#{document[:ref]}');")
    end
    return results.html_safe
  end

  def hide_component_button
    results = String.new
    if params[:component_level].to_i > 1
      results << link_to( image_tag("icons/button_close.png", :alt => "- Hide"),
        components_hide_path(:ead_id => params[:ead_id], :component_level => params[:component_level], :parent_ref => params["parent_ref"]),
        :id => "#{params["parent_ref"]}-switch",
        :remote => true)
      results << "<div id=\"#{params[:parent_ref]}-list\">"
    end
    return results.html_safe
  end

  def render_component_field(field,opts={})
    results = String.new
    if opts[:label]
      label = opts[:label]
    else
      if @document[(field.to_s + "_label").to_sym].nil?
        label = Blacklight.config[:ead_fields][field.to_sym][:label]
      else
        label = @document[(field.to_s + "_label")]
      end
    end
    unless @document[field.to_s].nil?
      results << "<dt>" + label + ":</dt>"
      results << "<dd class=\"#{field.to_s}\">" + display_field(@document[field.to_s]) + "</dd>"
    end
    return results.html_safe
  end


end
