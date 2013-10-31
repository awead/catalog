class Rockhall::EadComponent < SolrEad::Component

  include Rockhall::EadBehaviors

  @terminology = SolrEad::Component.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)

    # Alter our heading display if the title is blank
    if self.title.first.blank?
      heading = (solr_doc[Solrizer.solr_name("heading", :displayable)].to_s + self.unitdate.first.to_s)
      Solrizer.insert_field(solr_doc, "heading", heading, :displayable ) 
    end
    
    Solrizer.insert_field(solr_doc, "location", self.location_display, :displayable)
    Solrizer.insert_field(solr_doc, "accession", ead_accession_range(self.accession.first), :searchable)
    Solrizer.insert_field(solr_doc, "language", get_language_from_code(self.langcode.first), :facetable)

    solr_doc.merge!({"text" => [self.title, solr_doc["parent_unittitles_display"]].flatten })
  end

  def location_display(locations = Array.new)
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

end