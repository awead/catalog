module EadHelper


  def render_ead_html
    if params[:ref] == "full" or !has_json?
      render :file => "#{Rails.root}/public/fa/#{@document["ead_id"]}_full.html"
    else
      render :file => "#{Rails.root}/public/fa/#{@document["ead_id"]}.html"
    end
  end

  def render_collection_inventory_heading
    content_tag("h2", "Collection Inventory", :id => "inventory") if has_json?
  end

  def render_collection_inventory
    render :partial => "components/list", :locals => { :documents => @children } if has_json?
  end

  def render_ead_sidebar results = String.new
    results << "<div id=\"ead_sidebar\">"
    results << toggle_view_link if has_json?
    results << link_to("Archivist View", ead_xml_path(@document["ead_id"]), { :target => "_blank" })
    results << content_tag("div", ead_toc, {:id => "ead_toc"})
    return results.html_safe
  end

  def toggle_view_link link = String.new
    if params[:ref] == "full"
      link << link_to("Default View", catalog_path(params[:id]))
    else
      if params[:ref]
        link << link_to("Full View", catalog_path([params[:id], "full"], :anchor => params[:ref]))
      else
        link << link_to("Full View", catalog_path([params[:id], "full"]))
      end
    end
    return ("<div id=\"view_toggle\">" + link + "</div>").html_safe
  end

  def ead_toc results = String.new
    results << content_tag("h3", "Table of Contents")
    results << content_tag(:ol, ead_anchor_links)
    return results.html_safe
  end

  def ead_anchor_links results = String.new
    links = ["bioghist", "accruals", "separatedmaterial", "relatedmaterial", "custodhist"]
    results << content_tag(:li, link_to("Top", catalog_path(params[:id], :anchor => ""), :class => "ead_anchor"))
    results << content_tag(:li, link_to("Collection Overview", catalog_path(params[:id], :anchor => "abstract"), :class => "ead_anchor"))
    links.each do |anchor|
      field = anchor+"_heading_display"
      unless @document[field].nil?
        results << content_tag(:li, link_to(@document[field].first, catalog_path(params[:id], :anchor => anchor), :class => "ead_anchor"))
      end
    end
    results << content_tag(:li, link_to("Restrictions", catalog_path(params[:id], :anchor => "userestrict"), :class => "ead_anchor"))
    results << content_tag(:li, link_to("Subject Headings", catalog_path(params[:id], :anchor => "subjects"), :class => "ead_anchor"))
    results << content_tag(:li, link_to("Collection Inventory", catalog_path(params[:id], :anchor => "inventory"), :class => "ead_anchor"))
    return  results.html_safe
  end

  def has_json?
    File.exists?(File.join(Rails.root, "public", "fa", (@document["ead_id"] + "_toc.json"))) unless @document["ead_id"].nil?
  end


end