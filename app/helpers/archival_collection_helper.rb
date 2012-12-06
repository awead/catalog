module ArchivalCollectionHelper

  def deprecated_general_info
    results = String.new

    results << "<dl class=\"defList\">"
    results << gen_info_format(:title_display) unless @document[:title_display].nil?
    results << gen_info_format(:extent_display) unless @document[:extent_display].nil?

    # Dates get special treatment
    if @document[:date_display]
      results << "<dt class=\"blacklight-date_display\">Dates:</dt>"
      results << "<dd class=\"blacklight-date_display\">" + @document[:date_display].join(" ") + "</dd>"
    else
      unless @document[:inc_date_display].nil? and @document[:bulk_date_display].nil?
        results << "<dt class=\"blacklight-date_display\">Dates:</dt>"
        results << "<dd class=\"blacklight-date_display\">Inclusive, "
        results << @document[:inc_date_display].join(" ")
        unless @document[:bulk_date_display].nil?
          results << "; "
          results << @document[:bulk_date_display].join(" ")
        end
        results << "</dd>"
      end
    end

    results << gen_info_format(:language_display) unless @document[:language_display].nil?
    results << gen_info_format(:aid_language_display) unless @document[:aid_language_display].nil?
    results << gen_info_format(:citation_display) unless @document[:citation_display].nil?
    results << gen_info_format(:provenance_display) unless @document[:provenance_display].nil?
    results << gen_info_format(:usage_display) unless @document[:usage_display].nil?
    results << gen_info_format(:access_display) unless @document[:access_display].nil?
    results << gen_info_format(:process_display) unless @document[:process_display].nil?

    results << "</dl>"

    return results.html_safe
  end


  def deprecated_ead_headings
    results = String.new
    Rails.configuration.rockhall_config[:ead_headings].each do | field |
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


  def deprecated_ead_subject_headings
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


  def deprecated_bio_display
    results = String.new
    label = get_ead_label("bio_display")
    results << "<h2 id=\"bio_display\">#{label}</h2>"
    xml = Rockhall::EadMethods.ead_xml(@document)
    bio = xml.xpath("/ead/archdesc/bioghist")

    bio.children.each do |c|
      results << format_chronlist(c.to_xml) if c.name == "chronlist"
      results << c.to_xml if c.name == "p"
      results << format_source_list(c.to_xml) if c.name == "list"
    end
    results.gsub!(/<title/,"<span")
    results.gsub!(/<\/title/,"</span")
    results.gsub!(/&lt;title/,"<span")
    results.gsub!(/&lt;\/title/,"</span")
    results.gsub!(/&gt;/,">")
    results.gsub!(/render=/,"class=")
    return results.html_safe
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
    Rails.configuration.rockhall_config[:ead_headings].each do | f |
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
    if Rails.configuration.rockhall_config[:ead_fields][field.to_sym][:is_xpath]
      xml   = Rockhall::EadMethods.ead_xml(@document)
      label = xml.xpath(Rails.configuration.rockhall_config[:ead_fields][field.to_sym][:label]).text
    else
      label = Rails.configuration.rockhall_config[:ead_fields][field.to_sym][:label]
    end
    return label
  end

  def gen_info_format(field)
      results = String.new
      label = get_ead_label(field.to_sym)
      content = String.new
      if @document[field.to_sym].class.to_s.match("String")
        content << @document[field.to_sym]
      else
        @document[field.to_sym].each do |v|
          content << "#{v}<br/>"
        end
      end
      results << "<dt class=\"blacklight-#{field}\">" + label + ":</dt>"
      results << "<dd class=\"blacklight-#{field}\">" + content + "</dd>"
      return results
  end

  def format_chronlist(text)
    text.gsub!("<head>","<h4>")
    text.gsub!("</head>","</h4>")
    text.gsub!(/<eventgrp>\s+<event>/,"<dd>")
    text.gsub!(/<\/event>\s+<event>/,"<br/>")
    text.gsub!(/<\/event>\s+<\/eventgrp>/,"</dd>")
    text.gsub!("<chronitem>","")
    text.gsub!("<chronlist>","<dl class=\"defList\">")
    text.gsub!("</chronlist>","</dl>")
    text.gsub!("<date>","<dt>")
    text.gsub!("</date>","</dt>")
    text.gsub!("<event>","<dd>")
    text.gsub!("</event>","</dd>")
    text.gsub!("</chronitem>","")
    return text
  end

  def format_source_list(text)
    #results = String.new
    text.gsub!("<list numeration=\"lowerroman\" type=\"ordered\">","")
    text.gsub!("</list>","")
    text.gsub!("<head>","<h4>")
    text.gsub!("</head>","</h4>")
    text.gsub!("<item>","<p class=\"hangingindent\">")
    text.gsub!("</item>","</p>")
    #results = "<div id=\"hangingindent\">" + text + "</div>"
    return text
  end


end
