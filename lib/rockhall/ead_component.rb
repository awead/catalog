class Rockhall::EadComponent < SolrEad::Component

  include Rockhall::EadBehaviors

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
    Solrizer.insert_field(solr_doc, "format", "Archival Item", :symbol)
    Solrizer.insert_field(solr_doc, "heading", heading_display(solr_doc), :displayable)
    Solrizer.insert_field(solr_doc, "location", location_display, :displayable)
    Solrizer.insert_field(solr_doc, "accession", ead_accession_range(self.accession.first), :searchable)
    Solrizer.insert_field(solr_doc, "language", get_language_from_code(self.langcode.first), :facetable)
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
      line << " (" + self.find_by_xpath("//container[@id = '#{id}']/@label").text + ")"
      locations << line
    end
    return locations
  end

  def heading_display solr_doc
    if self.title.first.blank?
      self.unitdate.first.to_s unless self.unitdate.empty?
    else
      title_for_heading(solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)]) unless solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
    end
  end

  def title_for_heading parent_titles = Array.new
    if parent_titles.length > 0
      [parent_titles, self.title.first].join(" >> ")
    else
      self.title.first
    end
  end

end
