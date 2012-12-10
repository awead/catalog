class Rockhall::EadDocument < SolrEad::Document

  include Rockhall::EadBehaviors

  @terminology = SolrEad::Document.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"format"           => "Archival Collection"})
    solr_doc.merge!({"unitdate_display" => ead_date_display})

    # Facets
    solr_doc.merge!({"subject_topic_facet" => self.subject})
    solr_doc.merge!({"name_facet"          => self.corpname})
    solr_doc.merge!({"name_facet"          => self.persname})
    solr_doc.merge!({"genre_facet"         => self.genreform})

    return solr_doc
  end

end