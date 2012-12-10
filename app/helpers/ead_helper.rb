module EadHelper


  def render_ead_html
    if params[:ref] == "full" or !has_json?
      render :file => "#{Rails.root}/public/fa/#{@document["ead_id"]}_full.html"
    else
      render :file => "#{Rails.root}/public/fa/#{@document["ead_id"]}.html"
    end
  end

  def render_collection_inventory_heading
    content_tag("div", "Collection Inventory", :id => "inventory") if has_json?
  end

  def render_collection_inventory
    render :partial => "components/list", :locals => { :documents => @children } if has_json?
  end

  def render_ead_sidebar results = String.new
    results << "<div id=\"ead_sidebar\">"
    results << toggle_view_link if has_json?
    results << link_to("XML view", ead_xml_path(@document["ead_id"]), { :target => "_blank" })
    results << content_tag(:ul, ead_anchor_links, :id =>"ead_nav")
    if has_json?
      results << "<h5>Collection Inventory</h5>"
      results << "<div id=\"" + @document["ead_id"] + "_toc\" class=\"ead_toc\"></div>"
    end
    return results.html_safe
  end

  def toggle_view_link link = String.new
    if params[:ref] == "full"
      link << link_to("Default view", catalog_path(params[:id]))
    else
      if params[:ref]
        link << link_to("Full view", catalog_path([params[:id], "full"], :anchor => params[:ref]))
      else
        link << link_to("Full view", catalog_path([params[:id], "full"]))
      end
    end
    return ("<div id=\"view_toggle\">" + link + "</div>").html_safe
  end

  def ead_anchor_links results = String.new
    links = [
      "custodhist_label_z",
      "userestrict_label_z",
      "abstract_label_z",
      "bioghist_label_z",
      "accruals_label_z",
      "separatedmaterial_label_z",
      "relatedmaterial_label_z",
    ]
    results << content_tag(:li, link_to("General Information", catalog_path(params[:id], :anchor => "geninfo"), :class => "ead_anchor"))
    links.each do |field|
      anchor = field.split(/_/).first
      unless @document[field.to_sym].nil?
        results << content_tag(:li, link_to(@document[field.to_sym], catalog_path(params[:id], :anchor => anchor), :class => "ead_anchor"))
      end
    end
    results << content_tag(:li, link_to("Subject Headings", catalog_path(params[:id], :anchor => "subjects"), :class => "ead_anchor"))
    unless has_json?
      results << content_tag(:li, link_to("Collection Inventory", catalog_path(params[:id], :anchor => "inventory"), :class => "ead_anchor"))
    end
    return  results.html_safe
  end

  def has_json?
   File.exists?(File.join(Rails.root, "public", "fa", (@document["ead_id"] + "_toc.json"))) unless @document["ead_id"].nil?
  end


end