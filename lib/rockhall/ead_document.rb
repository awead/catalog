class Rockhall::EadDocument < SolrEad::Document

  include Rockhall::EadBehaviors

  use_terminology SolrEad::Document

  extend_terminology do |t|
    t.dsc
  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"text" => self.ng_xml.text})

    # Is there an inventory to this collection?
    if self.dsc.first.empty?
      solr_doc[Solrizer.solr_name("inventory", :type => :boolean)] = "false"
    else
      solr_doc[Solrizer.solr_name("inventory", :type => :boolean)] = "true"
    end

    Solrizer.insert_field(solr_doc, "heading",      heading_display,        :displayable) unless self.title_num.empty?
    Solrizer.insert_field(solr_doc, "format",       "Archival Collection",  :facetable)
    Solrizer.insert_field(solr_doc, "format",       "Archival Collection",  :displayable)
    Solrizer.insert_field(solr_doc, "unitdate",     ead_date_display,       :displayable)
    Solrizer.insert_field(solr_doc, "contributors", get_ead_names,          :displayable)
    Solrizer.insert_field(solr_doc, "name",         get_ead_names,          :facetable)
    Solrizer.insert_field(solr_doc, "title",        self.title_filing,      :sortable)

    Solrizer.set_field(solr_doc, "language",        get_language_from_code(self.langcode.first),  :facetable )
    Solrizer.set_field(solr_doc, "language",        get_language_from_code(self.langcode.first),  :displayable )
    Solrizer.set_field(solr_doc, "genre",           self.genreform,                               :facetable)
    Solrizer.set_field(solr_doc, "genre",           self.genreform,                               :displayable)
    Solrizer.set_field(solr_doc, "subject",         get_ead_subject_facets,                       :facetable)
    Solrizer.set_field(solr_doc, "subject",         self.subject,                                 :displayable)

    # Replace certain fields with their html-formatted equivilents
    Solrizer.set_field(solr_doc, "title", self.term_to_html("title"), :displayable)
    
    return solr_doc
  end

  protected

  def heading_display
    "Guide to the " + self.term_to_html("title") + " (" + self.title_num.first + ")"
  end

end