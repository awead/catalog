module ComponentsHelper


  def continue_components document
    if @parents.nil?
      next_component_button(document)
    else
      if @parents.has_key?(document["ref_id"])
        render :partial => "components/list", :locals => { :documents => @parents[document["ref_id"]] }
      else
        next_component_button(document)
      end
    end
  end

  def next_component_button document, results = String.new
    if document["component_children_b"]
      results << link_to( image_tag("icons/button_open.png", :alt => "+ Show"),
        components_path( :parent_ref => document["ref_id"], :ead_id => document["ead_id"] ),
        :title  => "Click to open",
        :id     => "#{document["ref_id"]}-open",
        :class  => "next_component_button")
      results << image_tag("icons/waiting.gif", :alt => "Loading...", :id => "#{document["ref_id"]}-open-waiting", :class => "hidden")
    end
    return results.html_safe
  end

  def hide_component_button
    if params["parent_ref"]
      image_tag("icons/button_close.png", :alt => "- Hide", :id => (params["parent_ref"] + "-close"), :class  => "close_component_button")
    end
  end

  def should_display_component_field? field
    result = case field
      when "title_display" then false
      when "format" then false
      when "collection_facet" then false
      when "unitdate_display" then false
      when "id" then false
      else true  
    end
  end

  def render_list_id
    params[:parent_ref].nil? ? (params[:id]+"-list") : (params[:ead_id]+params[:parent_ref]+"-list")
  end

  def display_field field
    field.join("<br/>").html_safe
  end

  def comma_list args
    fields = Array.new
    args.each do |text|
      unless text.nil?
        fields << text
      end
    end
    return fields.join(", ").html_safe
  end


end