module ArchivalCollectionHelper


  def general_info
    results = String.new
    results << "<table>"
    Blacklight.config[:ead_fields][:field_names].each do | field |
      label = Blacklight.config[:ead_fields][:labels][field.to_s]
      unless @document[field.to_s].nil? or label.nil?
        results << "<tr><td><b>#{label}:</b></td>"
        results << "<td>"
        @document[field.to_s].each do |v|
          results << "#{v}<br/>"
        end
        results << "</td></tr>"
      end
    end
    results << "</table>"
    return results.html_safe
  end


  def ead_headings
    results = String.new
    Blacklight.config[:ead_fields][:field_names].each do | field |
      label = Blacklight.config[:ead_fields][:headings][field.to_s]
      unless label.nil?
        # Override display from Solr field with partial
        if self.respond_to?(field.to_sym)
          results << self.send(field.to_sym)
        else
          unless @document[field.to_s].nil?
            results << "<h2 id=\"#{field}\">#{label}</h2>"
            @document[field.to_s].each do | v|
              results << "<p>#{v}</p>"
            end
          end
        end
      end
    end
    return results.html_safe
  end


  def ead_access_headings
    results = String.new
    unless @document["subject_topic_facet"].nil?
      results << "<h2 id=\"access_headings\">Controlled Access Headings</h2>"
      results << "<ul>"
      @document["subject_topic_facet"].sort.each do |v|
        results << "<li>#{v}</li>"
      end
      results << "</ul>"
    end
    return results.html_safe
  end


  def ead_bio_display
    results = String.new
    results << "<h2 id=\"ead_bio_display\">#{Blacklight.config[:ead_fields][:headings]["ead_bio_display"]}</h2>"

    xml   = Rockhall::EadMethods.ead_xml(@document)
    list  = xml.xpath("/ead/archdesc/bioghist/chronlist")
    items = list.xpath('chronitem')

    # Timeline table
    results << "<table>"
    items.each do |chronitem|
      results << "<tr><td>" + chronitem.xpath('date').first + "</td><td>"
      chronitem.xpath('.//event').each do |chronevent|
        results << chronevent.text + "<br/>"
      end
      results << "</td></tr>"
    end
    results << "</table>"

    @document[:ead_bio_display].each do | v|
      results << "<p>#{v}</p>"
    end

    # Sources
    results << "<h3>Sources</h3>"
    xml.xpath("/ead/archdesc/bioghist/list/item").each do |source|
      results << "<p>#{source.text}</p>"
    end

    results.gsub!("<title render=\"italic\">","<i>")
    results.gsub!("</title>","</i>")

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


  def ead_contents
    results = String.new
    Blacklight.config[:ead_fields][:field_names].each do |f|
      unless Blacklight.config[:ead_fields][:headings][f.to_s].nil? or @document[f.to_s].nil?
        results << "<li>"
        results << "<a href=\"#" + f + "\">#{Blacklight.config[:ead_fields][:headings][f.to_s]}</a>"
        results << "</li>"
      end
    end
    return results.html_safe
  end


end