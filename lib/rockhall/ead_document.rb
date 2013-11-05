class Rockhall::EadDocument < SolrEad::Document

  include Rockhall::EadBehaviors

  @terminology = SolrEad::Document.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"text"   => self.ng_xml.text})
    Solrizer.insert_field(solr_doc, "unitdate", ead_date_display, :displayable)
    Solrizer.insert_field(solr_doc, "language", get_language_from_code(self.langcode.first), :facetable )
    Solrizer.insert_field(solr_doc, "genre", self.genreform, :facetable)
    Solrizer.insert_field(solr_doc, "contributors", get_ead_names, :displayable)
    Solrizer.insert_field(solr_doc, "name", get_ead_names, :facetable)
    Solrizer.insert_field(solr_doc, "subject", self.subject, :displayable)
    Solrizer.insert_field(solr_doc, "subject", get_ead_subject_facets, :facetable)
    return solr_doc
  end

end