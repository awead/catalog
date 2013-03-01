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

  # Subject facets are arrays of terms, so we need to handle them a bit differently.
  # If there's only one term, then we just call our fact_link method, otherwise,
  # we roll our own paramters hash.
  def subject_facet_link text, terms
    if terms.count == 1
      facet_link text, "subject_facet"
    else
      new_params = Hash.new
      new_params[:action] = "index"

      # {"f"=>{"subject_facet"=>["Inductee", "Rock musicians"]}}
      new_params[:f] = Hash.new
      new_params[:f]["subject_facet"] = terms
      link_to(text, 
            new_params, 
            :class=>"facet_select label")
    end    
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

  def render_subjects args, results = Array.new
    if args[:document]["marc_display"]
      format_subjects(args[:document]["marc_display"]).each do |line|
        results << subject_array_to_links(line)
      end
    end
    return results.join(field_value_separator).html_safe
  end

  def subject_array_to_links array, results = Array.new
    links = format_subject_links(array)
    links.each do |text, terms|
      results << subject_facet_link(text, terms)
    end
    return results.join("--")
  end

  # Takes an array of subject terms and returns a hash of term keys
  # and their corresponding query terms.
  # Ex:
  #   [ "Rock musicians", "England", "Biography" ]
  # results in:
  # { "Rock musicians" => ["Rock Musicians"], 
  #   "England"        => ["Rock Musicians", "England"],
  #   "Biography"      => ["Rock Musicians", "England", "Biography"]
  # }
  def format_subject_links array, results = Hash.new
    array.each_index do |i|
      if i == 0
        results[array[i]] = Array.new
        results[array[i]] << array[i]
      else
        results[array[i]] = Array.new
        (0..i).each do |ti|
          results[array[i]] << array[ti]
        end
      end
    end
    return results
  end

  # Takes the marc xml from marc_display and returns a 2D array of all our subjects
  # formatted accordingly.  Fields in the subjects array are returned as arrays
  # of strings for each subfield, while fields in the namedsubjects array have their
  # a-d subfields joined into one string and all other subfields as individual strings.
  def format_subjects string, results = Array.new
    subjects      = ["610", "630", "650", "651"]
    namedsubjects = ["600", "611"]

    record = MARC::XMLReader.new(StringIO.new(string)).first
    (subjects + namedsubjects).sort.each do |i|
      record.find_all {|f| f.tag == i}.each do |field|
        if namedsubjects.include?(i)
          results << subject_field_with_name(field)
        else
          results << subject_field_without_name(field)
        end
      end
    end

    return results
  end

  # Takes one MARC::DataField and returns an array of subfields as:
  #   * $a through $d joined togeter into one string
  #   * $e through $z as individual strings
  # Example:
  #   600 10 $a Lennon, John, $d 1940-1980 $x Assassination
  # is returned as:
  #   [ "Lennon, John, 1940-1980", "Assassination"] 
  def subject_field_with_name field, results = Array.new
    results << field.collect {|x| x.value.strip.gsub(/[\.\;\:]$/,"") if ("a".."d").include?(x.code) }.join(" ").strip
    field.collect {|x| x.value.strip.gsub(/[\.\;\:]$/,"") if ("e".."z").include?(x.code) }.each do |subfield|
      results << subfield unless subfield.nil?
    end
    return results
  end

  # Takes one MARC::DataField and returns an array of each subfield.
  # Example:
  #   650  0 $a Rock musicians $z England $v Biography
  # is returned as:
  #   
  def subject_field_without_name field, results = Array.new
    field.collect {|x| x.value.strip.gsub(/[\.\;\:]$/,"") if ("a".."z").include?(x.code) }.each do |subfield|
      results << subfield unless subfield.nil?
    end
    return results
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