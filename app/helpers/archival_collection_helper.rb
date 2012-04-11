module ArchivalCollectionHelper


  def general_info
    results = String.new

    results << "<dl class=\"defList\">"
    results << gen_info_format(:title_display) unless @document[:title_display].nil?
    results << gen_info_format(:ead_extent_display) unless @document[:ead_extent_display].nil?

    # Dates get special treatment
    if @document[:ead_date_display]
      results << "<dt class=\"blacklight-ead_date_display\">Dates:</dt>"
      results << "<dd class=\"blacklight-ead_date_display\">" + @document[:ead_date_display].to_s + "</dd>"
    else
      unless @document[:ead_inc_date_display].nil? and @document[:ead_bulk_date_display].nil?
        results << "<dt class=\"blacklight-ead_date_display\">Dates:</dt>"
        results << "<dd class=\"blacklight-ead_date_display\">Inclusive, "
        results << @document[:ead_inc_date_display].to_s
        unless @document[:ead_bulk_date_display].nil?
          results << "; "
          results << @document[:ead_bulk_date_display].to_s
        end
        results << "</dd>"
      end
    end

    results << gen_info_format(:ead_lang_coll_display) unless @document[:ead_lang_coll_display].nil?
    results << gen_info_format(:ead_lang_display) unless @document[:ead_lang_display].nil?
    results << gen_info_format(:ead_citation_display) unless @document[:ead_citation_display].nil?
    results << gen_info_format(:ead_provenance_display) unless @document[:ead_provenance_display].nil?
    results << gen_info_format(:ead_use_display) unless @document[:ead_use_display].nil?
    results << gen_info_format(:access_display) unless @document[:access_display].nil?
    results << gen_info_format(:ead_process_display) unless @document[:ead_process_display].nil?

    results << "</dl>"

    return results.html_safe
  end


  def ead_headings
    results = String.new
    Blacklight.config[:ead_headings].each do | field |
      label = get_ead_label(field.to_sym)
      # Override display from Solr field with a method
      if self.respond_to?(field.to_sym)
        results << self.send(field.to_sym)
      else
        unless @document[field.to_s].nil?
          results << "<h2 id=\"#{field.to_s}\">#{label}</h2>"
          @document[field.to_s].each do | v|
            results << "<p>#{v}</p>"
          end
        end
      end
    end
    return results.html_safe
  end


  def ead_subject_headings
    results = String.new
    results << "<h2 id=\"subject_headings\">Subject Headings</h2>"
    results << "<dl class=\"defList\">"

    # Topics
    unless @document["subject_topic_facet"].nil?
      results << "<dt>Subjects:</dt>"
      results << "<dd>"
      @document["subject_topic_facet"].sort.each do |v|
        results << link_to(v, add_facet_params_and_redirect("subject_topic_facet", v), :class=>"facet_select label")
        results << "<br/>"
      end
      results << "</dd>"
    end

    # Names
    unless @document["name_facet"].nil?
      results << "<dt>Contributors:</dt>"
      results << "<dd>"
      @document["name_facet"].sort.each do |v|
        results << link_to(v, add_facet_params_and_redirect("name_facet", v), :class=>"facet_select label")
        results << "<br/>"
      end
      results << "</dd>"
    end

    # Genres
    unless @document["genre_facet"].nil?
      results << "<dt>Genres:</dt>"
      results << "<dd>"
      @document["genre_facet"].sort.each do |v|
        results << link_to(v, add_facet_params_and_redirect("genre_facet", v), :class=>"facet_select label")
        results << "<br/>"
      end
      results << "</dd>"
    end

    results << "</dl>"
    return results.html_safe
  end


  def ead_bio_display
    results = String.new
    label = get_ead_label("ead_bio_display")
    results << "<h2 id=\"ead_bio_display\">#{label}</h2>"

    xml   = Rockhall::EadMethods.ead_xml(@document)
    list  = xml.xpath("/ead/archdesc/bioghist/chronlist")
    items = list.xpath('chronitem')

    unless list.empty?
      # Timeline table
      results << "<dl class=\"defList\">"
      items.each do |chronitem|
        results << "<dt>" + chronitem.xpath('date').first + "</dt>"
        results << "<dd>"
        chronitem.xpath('.//event').each do |chronevent|
          results << chronevent.text + "<br/>"
        end
        results << "</dd>"
      end
      results << "</dl>"
    end

    unless @document[:ead_bio_display].nil?
      @document[:ead_bio_display].each do | v|
        results << "<p>#{v}</p>"
      end
    end

    # Sources
    sources = String.new
    xml.xpath("/ead/archdesc/bioghist/list/item").each do |source|
      sources << "<p>#{source.text}</p>"
    end
    unless sources.empty?
      results << "<h3>Sources</h3>"
      results << sources
    end

    results.gsub!("<title render=\"italic\">","<em>")
    results.gsub!("</title>","</em>")

    return results.html_safe
  end


  def comma_list(args)
    fields = Array.new
    args.each do |text|
      unless text.nil?
        fields << text
      end
    end
    return fields.join(", ").html_safe
  end

  def display_field(field)
    field.join("<br/>").html_safe
  end

  def display_odd_fields(fields,labels)
    results = String.new
    if labels.length == fields.length
      last_index = labels.length - 1
      (0..last_index).each do |index|
        results << "<dt>#{labels[index]}:</dt>"
        results << "<dd class=\"odd\">#{fields[index]}</dd>"
      end
    else
      results << "Unable to display additional fields"
    end
    return results.html_safe
  end


  def ead_contents
    results = String.new
    Blacklight.config[:ead_headings].each do | f |
      # Always show the link if we're overriden it as above
      if !@document[f.to_sym].nil? or self.respond_to?(f.to_sym)
        label = get_ead_label(f.to_sym)
        results << "<li>"
        results << "<a href=\"#" + f.to_s + "\">#{label}</a>"
        results << "</li>"
      end
    end
    return results.html_safe
  end

  def get_ead_label(field)
    if Blacklight.config[:ead_fields][field.to_sym][:is_xpath]
      xml   = Rockhall::EadMethods.ead_xml(@document)
      label = xml.xpath(Blacklight.config[:ead_fields][field.to_sym][:label]).text
    else
      label = Blacklight.config[:ead_fields][field.to_sym][:label]
    end
    return label
  end

  def gen_info_format(field)
      results = String.new
      label = get_ead_label(field.to_sym)
      content = String.new
      @document[field.to_sym].each do |v|
        content << "#{v}<br/>"
      end
      results << "<dt class=\"blacklight-#{field}\">" + label + ":</dt>"
      results << "<dd class=\"blacklight-#{field}\">" + content + "</dd>"
      return results
  end

end
