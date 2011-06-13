module Rockhall::EadMethods

  require 'rexml/document'
  include REXML
  
  def self.ead_link_id(element, xpath)
    element.attribute('id') || xpath.split('/').last
  end

  def self.ead_increment_start(start)
    number = start[1,5].to_i + 1
    start_number = "%02d" % number
    'c' + start_number
  end
  
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
  
  def self.ead_text(element, xpath)
    first = element.xpath(xpath).first
    if first
      first.text
    end
  end  
  
  def self.ead_paragraphs(element)
    if element
      element.xpath('p').map do |p|
        if !p.xpath('list').blank?
          p.xpath('list').map do |list|
            '<p>' + ead_list(list) + '</p>'
          end
        else
          '<p>' +  p.text + '</p>'
        end

      end
    end
  end
  
  
  def self.get_component_doc(node,level)
    part, children = ead_prep_component(node,level)
    # Required fields
    doc = {
      :id => [ead_id(node), level, node.attr("id")].join(":"),
      :ead_id => ead_id(node),
      #:ead_facet => node.attr("level"),
      :component_level => level,
      :component_children_b => children,
      :ref => node.attr("id"),
      :parent_ref => node.parent.attr("id"),
      :parent_ref_list => ead_parent_refs(node,level),
      :parent_unittitle_list => ead_parent_unittitles(node,level),
      :collection_display => ead_collection(node),
      :text => part.text,
      :xml_display => part.to_xml
    }    
    
    # Optional fields
    {
      "title_display"              => "//c0#{level}/did/unittitle",
      "unitdate_display"           => "//c0#{level}/did/unitdate",
      "physdesc_display"           => "//c0#{level}/did/physdesc",
      "odd_display"                => "//c0#{level}/odd/p",
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
    
    # only components with containers will get faceted
    material = ead_material(part)
    unless material.nil?
      doc.merge!({ :material_facet => material })
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
