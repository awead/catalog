class Rockhall::EadDocument < SolrEad::Document

  include Rockhall::EadBehaviors

  @terminology = SolrEad::Document.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"format"           => "Archival Collection"})
    solr_doc.merge!({"unitdate_display" => ead_date_display})
    solr_doc.merge!({"text"             => self.ng_xml.text})
    solr_doc.merge!({"language_facet"   => get_language_from_code(self.langcode.first) })

    # Facets
    solr_doc.merge!({"genre_facet"         => self.genreform})

    # Gather persname and corpame together as  contributors_display to match what we do with MARC
    # copyt this to name_facet
    solr_doc["contributors_display"] = (self.corpname + self.persname).flatten.compact.uniq.sort
    solr_doc["name_facet"] = solr_doc["contributors_display"]

    # Split out subjects into individual terms; save original subject headings from EAD for display
    solr_doc["subject_display"] = self.subject
    new_subject_facet = Array.new
    self.subject.each do |term|
      splits = term.split(/--/)
      new_subject_facet << splits
    end
    solr_doc["subject_facet"] = new_subject_facet.flatten.compact.uniq.sort

    return solr_doc
  end

end