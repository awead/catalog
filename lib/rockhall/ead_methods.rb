module Rockhall::EadMethods


  def self.ead_rake_xml(file)
    raw = File.read(file)
    raw.gsub!(/xmlns=".*"/, '')
    xml = Nokogiri::XML(raw)
  end

  def self.ead_id(xml)
    raise "Null ID. This is mostly likely a problem with the ead" if xml.at('/ead/eadheader/eadid').text.empty?
    id = xml.at('/ead/eadheader/eadid').text.gsub(/\.xml/, '')
    id.gsub!(/\./, '-')
    return id
  end

  def self.ead_collection(xml)
    xml.xpath("//archdesc/did/unittitle").first.text.gsub("\n",'').gsub(/\s+/, ' ').strip
  end

  def self.ead_xml(document)
    xml_doc = document['xml_display'].first
    xml_doc.gsub!(/xmlns=".*"/, '')
    xml_doc.gsub!('ns2:', '')
    Nokogiri::XML(xml_doc)
  end

  def self.ead_rexml(document)
    xml_doc = document['xml_display'].first
    xml_doc.gsub!(/xmlns=".*"/, '')
    xml_doc.gsub!('ns2:', '')
    Document.new(xml_doc)
  end

  # Note: only handles ranges in the last set of digits
  def self.ead_accession_range(range)
    results = Array.new
    first, last = range.split(/-/)
    numbers = range.split(/,/)

    if numbers.length > 1
      numbers.each do |n|

      first, last = n.split(/-/)
        if last
          fparts = first.strip.split(/\./)
          lparts = last.strip.split(/\./)
          (fparts[2]..lparts[2]).each { |n| results << fparts[0] + "." + fparts[1] + "." + n }
        else
          results << n.strip
        end

      end
    elsif last
      fparts = first.strip.split(/\./)
      lparts = last.strip.split(/\./)
      (fparts[2]..lparts[2]).each { |n| results << fparts[0] + "." + fparts[1] + "." + n }
    else
      results << range.strip
    end

    return results

  end

  def self.ead_accessions(node)
    results = Array.new
    node.xpath('//head[contains(., "Museum Accession Number")]').each do | n |
      ead_accession_range(n.next_element.text).each { |a| results << a }
    end

    if results.length > 1
      return results.uniq
    else
      return nil
    end
  end

  def self.get_ead_doc(xml)

    title = xml.at('//eadheader/filedesc/titlestmt/titleproper').text.gsub("\n",'').gsub(/\s+/, ' ').strip
    num = xml.at('//eadheader/filedesc/titlestmt/titleproper/num').text
    title.sub!(num, '(' + num + ')')

    solr_doc = {
      :format => Blacklight.config[:ead_format_name],
      :title_display => title,
      :heading_display => "Finding Aid: " + title,
      :institution_t => xml.at('//publicationstmt/publisher').text,
      :ead_filename_s => xml.at('//eadheader/eadid').text,
      :id => Rockhall::EadMethods.ead_id(xml),
      :xml_display => xml.to_xml,
      :text => xml.text,
    }

    Blacklight.config[:ead_fields][:xpath].each do | field, xpath |
      result = ead_solr_field(xml,xpath,field)
      unless result.nil?
        solr_doc.merge!(result)
      end
    end

    return solr_doc

  end


  def self.get_component_doc(node,level)
    part, children = ead_prep_component(node,level)
    collection = ead_collection(node)
    title = ead_solr_field(part,"//c0#{level}/did/unittitle","unittitle_display").values.first.to_s

    # Required fields
    doc = {
      :id => [ead_id(node), level, node.attr("id")].join(":"),
      :ead_id => ead_id(node),
      #:ead_facet => node.attr("level"),
      :heading_display => collection + ": " + ead_parent_unittitles(node,level).join(" - ") + " - " + title,
      :component_level => level,
      :component_children_b => children,
      :ref => node.attr("id"),
      :parent_ref => node.parent.attr("id"),
      :parent_ref_list => ead_parent_refs(node,level),
      :parent_unittitle_list => ead_parent_unittitles(node,level),
      :collection_display => collection,
      :collection_facet => collection,
      :text => part.text,
      :xml_display => part.to_xml
    }

    # Optional fields
    {
      "title_display"              => "//c0#{level}/did/unittitle",
      "unitdate_display"           => "//c0#{level}/did/unitdate",
      "physdesc_display"           => "//c0#{level}/did/physdesc",
      "odd_display"                => "//c0#{level}/odd/p",
      "odd_label_display"          => "//c0#{level}/odd/head",
      "scopecontent_display"       => "//c0#{level}/scopecontent/p",
      "accessrestrict_display"     => "//c0#{level}/accessrestrict/p",
      "processinfo_display"        => "//c0#{level}/processinfo/p",
      "separatedmaterial_display"  => "//c0#{level}/originalsloc/p",
      "originalsloc_display"       => "//c0#{level}/originalsloc/p",
      "phystech_display"           => "//c0#{level}/phystech/p",
      "altformavail_display"       => "//c0#{level}/altformavail/p",
      "userestrict_display"        => "//c0#{level}/userestrict/p",
      "bioghist_display"           => "//c0#{level}/bioghist/p"
    }.each do | field, xpath |
      result = ead_solr_field(part,xpath,field)
      unless result.nil?
        doc.merge!(result)
      end
    end

    location = ead_location(part)
    unless location.nil?
      doc.merge!({ :location_display => location })
    end

    # Components with containers, representing individual items,
	# get faceted with their material type and a general format type
	# Otherwise, they are marked as a series and supressed from search results.
    material = ead_material(part)
    if material.nil?
      doc.merge!({ :series_b => TRUE })
    else
      doc.merge!({ :material_facet => material })
	  doc.merge!({ :format => Blacklight.config[:ead_component_name] })
    end

    # index accession numbers and ranges
    accessions = ead_accessions(part)
    unless accessions.nil?
      doc.merge!({ :accession_s => accessions })
    end

    return doc
  end

  def ead_solr_field(part,xpath,field)
    unless part.at(xpath).nil?
      lines = Array.new
      part.xpath(xpath).each do |line|
        if line.text.empty?
          lines << "[Blank]"
        else
          lines << line.text.gsub("\n",'').gsub(/\s+/, ' ').strip
        end
      end
      { field.to_sym => lines }
    end
  end


  def ead_location(node)
    r = Array.new
    ["box", "folder", "object", "bin", "cassette", "disk", "drawer", "shelf"].each do |type|
      value = node.search("container[@type='#{type.capitalize}']").text
      unless value.empty?
        r << [type.capitalize, value].join(": ")
      end
    end
    return r.join(", ")
  end

  def ead_material(node)
    value = node.search("container[@label]")
    if value.first.respond_to?(:attr)
      return value.first.attr("label")
    end
  end

  def ead_prep_component(node,level)
    part = Nokogiri::XML(node.to_xml)
    next_level = level.to_i + 1
    if part.search("//c0#{next_level}").count > 0
      part.search("//c0#{next_level}").each { |subpart| subpart.remove }
      return part, "true"
    else
      return part, "false"
    end
  end

  def ead_parent_refs(node,level)
    results = Array.new
    while level > 0
      level = level - 1
      parent = node.parent
      results << parent.attr("id")
      node = parent
    end
    return results
  end

  def ead_parent_unittitles(node,level)
    results = Array.new
    # decrement now to avoid looking for "c00" nodes
    level = level - 1
    while level > 0
      parent = node.parent
      part = Nokogiri::XML(parent.to_xml)
      field = part.at("//c0#{level}/did/unittitle")
      unless field.nil?
        results << field.text.gsub("\n",'').gsub(/\s+/, ' ').strip
      end
      node = parent
      level = level - 1
    end
    return results
  end



end
