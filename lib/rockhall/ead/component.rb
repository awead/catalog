class Rockhall::Ead::Component < SolrEad::Component

  include Rockhall::Ead::Behaviors

  use_terminology SolrEad::Component

  extend_terminology do |t|

    # <odd> nodes
    # These guys depend on what's in <head> so we do some xpathy stuff...
    t.note(:path=>'odd[./head="General note"]/p', :index_as=>[:displayable])
    t.accession(:path=>'odd[./head[starts-with(.,"Museum Accession")]]/p', :index_as=>[:displayable])
    t.print_run(:path=>'odd[./head[starts-with(.,"Limited")]]/p', :index_as=>[:displayable])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"text" => self.ng_xml.text})
    Solrizer.insert_field(solr_doc, "format",     "Archival Item",                            :facetable)
    Solrizer.insert_field(solr_doc, "format",     "Archival Item",                            :displayable)
    Solrizer.insert_field(solr_doc, "heading",    heading_display(solr_doc),                  :displayable)
    Solrizer.insert_field(solr_doc, "location",   location_display,                           :displayable)
    Solrizer.insert_field(solr_doc, "accession",  ead_accession_range(self.accession.first),  :searchable)

    # Collection field
    Solrizer.set_field(solr_doc, "collection", collection_name(solr_doc), :displayable)
    Solrizer.set_field(solr_doc, "collection", collection_name(solr_doc), :facetable)

    # Replace certain fields with their html-formatted equivilents
    Solrizer.set_field(solr_doc, "title", self.term_to_html("title"), :displayable)

    # Set lanuage codes
    solr_doc.merge!(ead_language_fields)

  end

  protected

  def location_display locations = Array.new
    self.container_id.each do |id|
      line = String.new
      line << (self.find_by_xpath("//container[@id = '#{id}']/@type").text + ": ")
      line << self.find_by_xpath("//container[@id = '#{id}']").text
      sub_containers = Array.new
      self.find_by_xpath("//container[@parent = '#{id}']").each do |sub|
        sub_containers << sub.attribute("type").text + ": " + sub.text
      end
      line << (", " + sub_containers.join(", ") ) unless sub_containers.empty?
      locations << line
    end
    return locations
  end

  def heading_display solr_doc
    if solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
      component_title_for_heading
    else
      heading_elements(solr_doc).join(" >> ")
    end
  end

  def heading_elements solr_doc
    solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)] + [component_title_for_heading]
  end

  def collection_name solr_doc
    solr_doc[Solrizer.solr_name("collection", :facetable)].strip
  end

  def component_title_for_heading
    if self.title.first.blank?
      self.unitdate.empty? ? "[No title]" : self.term_to_html("unitdate")
    else
      self.term_to_html("title")
    end
  end

end
