class Rockhall::EadDocument < SolrEad::Document

  include Rockhall::EadBehaviors

  use_terminology SolrEad::Document

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"text" => self.ng_xml.text})
    Solrizer.insert_field(solr_doc, "heading", heading_display, :displayable) unless self.title_num.empty?
    Solrizer.insert_field(solr_doc, "format", "Archival Collection", :symbol)
    Solrizer.insert_field(solr_doc, "unitdate", ead_date_display, :displayable)
    Solrizer.insert_field(solr_doc, "language", get_language_from_code(self.langcode.first), :facetable )
    Solrizer.insert_field(solr_doc, "genre", self.genreform, :facetable)
    Solrizer.insert_field(solr_doc, "contributors", get_ead_names, :displayable)
    Solrizer.insert_field(solr_doc, "name", get_ead_names, :facetable)
    Solrizer.insert_field(solr_doc, "subject", self.subject, :displayable)
    Solrizer.set_field(solr_doc, "subject", get_ead_subject_facets, :facetable)
    return solr_doc
  end

  protected

  def heading_display
    "Guide to the " + self.title.first + " (" + self.title_num.first + ")"
  end

end