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
    solr_doc.merge!({"name_facet"          => self.corpname})
    solr_doc.merge!({"name_facet"          => self.persname})
    solr_doc.merge!({"genre_facet"         => self.genreform})

    # Copy name_facet to contributors_display to match what we do with MARC
    solr_doc["contributors_display"] = solr_doc["name_facet"]

    # Split out subjects into individual terms; save original subject headings from EAD for display
    solr_doc["subject_display"] = self.subject
    new_subject_facet = Array.new
    self.subject.each do |term|
      splits = term.split(/--/)
      new_subject_facet << splits
    end
    solr_doc["subject_facet"] = new_subject_facet.flatten.compact.uniq

    return solr_doc
  end

end