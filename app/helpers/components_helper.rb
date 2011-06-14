module ComponentsHelper

  require 'rexml/document'
  include REXML

  def parent_ead_id
    parts = params[:id].split(":")
    return parts[0]
  end

  # not working...
  def render_components(documents)
    documents.each do |document|
      render :partial => "catalog/_show_partials/_ead/component", :locals => {
        :level => params[:level],
        :document => document,
        :children => document["component_children_b"] }
     end
  end

  # warning: ugly, spaghetti code follows...
  def component_trail(doc)
    result = String.new
    titles = doc["parent_unittitle_list"].reverse
    refs   = doc["parent_ref_list"].reverse
    level  = 1
    index  = 0
    link = doc["component_level"] - 2
    while level < doc["component_level"]
      next_level = level + 1
      result << "<div class=\"component_part clearfix c0#{level}\">"
      result << "<h5 id=\"#{refs[index]}\">"
      if link > 0
        result << "<span class=\"unittitle\">"
        result << link_to(titles[index], components_path(
          :parent_ref => refs[index],
          :ead_id     => params[:ead_id],
          :level      => next_level ))
        result << "</span>"
      else
        result << "<span class=\"unittitle\">#{titles[index]}</span>"
      end
      result << "</h5>"
      result << "</div>"
      level = level + 1
      index = index + 1
      link  = link - 1
    end
    return result
  end


end
