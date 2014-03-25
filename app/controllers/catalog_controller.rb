# -*- encoding : utf-8 -*-
class CatalogController < ApplicationController

  include Rockhall::Catalog

  SolrDocument.use_extension ::Rockhall::Exports

  before_filter :get_component, :get_component_children, :show_item_within_collection, :only => :show

  configure_blacklight do |config|
    config.default_solr_params = {
      :qt => "search",
      :rows => 10,
      ("hl.fl").to_sym => "heading_ssm, author_ssm, publisher_ssm, collection_ssm, location_ssm",
      ("hl.simple.pre").to_sym => '<span class="highlight">',
      ("hl.simple.post").to_sym => "</span>",
      :hl => true
    }

    config.default_document_solr_params = {
      ("hl.fl").to_sym => "title_ssm, heading_ssm, author_ssm, publisher_ssm, collection_ssm, location_ssm",
      ("hl.simple.pre").to_sym => '<span class="highlight">',
      ("hl.simple.post").to_sym => "</span>",
      :hl => true
    }

    # solr field configuration for search results/index views
    config.index.title_field = solr_name("heading", :displayable)
    config.index.display_type_field = solr_name("format", :displayable)

    # solr field configuration for document/show views
    config.show.title_field = solr_name("title", :displayable)
    config.show.display_type_field = solr_name("format", :displayable)

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    config.add_facet_field solr_name("format",     :facetable), :label => "Format",             :limit => 20, :collapse => false
    config.add_facet_field solr_name("collection", :facetable), :label => "Collection Name",    :limit => 20
    config.add_facet_field solr_name("material",   :facetable), :label => "Archival Material",  :limit => 20
    config.add_facet_field solr_name("name",       :facetable), :label => "Name",               :limit => 20
    config.add_facet_field solr_name("subject",    :facetable), :label => "Subject",            :limit => 20
    config.add_facet_field solr_name("genre",      :facetable), :label => "Genre",              :limit => 20    
    config.add_facet_field solr_name("series",     :facetable), :label => "Event/Series",       :limit => 20
    config.add_facet_field solr_name("pub_date",   :facetable), :label => "Publication Date",   :limit => 20
    config.add_facet_field solr_name("language",   :facetable), :label => "Language",           :limit => true
    

    # TODO: Maybe add this in later
    #config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
    # :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
    # :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
    # :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    #}

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!
    
    
    # ------------------------------------------------------------------------------------------
    #
    # Index view fields
    #
    # ------------------------------------------------------------------------------------------
    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name("author",            :displayable),  :label => "Author", 
                                                                          :helper_method => :render_facet_link,
                                                                          :highlight => true
    
    config.add_index_field solr_name("format",            :displayable),  :label => "Format"
    config.add_index_field solr_name("ohlink_url",        :displayable),  :label => "OhioLink Resource", 
                                                                          :helper_method => :render_external_link

    config.add_index_field solr_name("resource_url",      :displayable),  :label => "Online Resource",
                                                                          :helper_method => :render_external_link

    config.add_index_field solr_name("language",          :displayable),  :label => "Language"
    config.add_index_field solr_name("publisher",         :displayable),  :label => "Publisher"
    config.add_index_field solr_name("lc_callnum",        :displayable),  :label => "Call Number"
    config.add_index_field solr_name("unitdate",          :displayable),  :label => "Dates"

    config.add_index_field solr_name("collection",        :displayable),  :label => "Archival Collection", 
                                                                          :helper_method => :render_facet_link,
                                                                          :highlight => true

    config.add_index_field solr_name("location",          :displayable),  :label => "Container",
                                                                          :highlight => true

    config.add_index_field solr_name("material",          :displayable),  :label => "Archival Material",
                                                                          :highlight => true

    # ------------------------------------------------------------------------------------------
    #
    # Show view fields (individual record)
    #
    # ------------------------------------------------------------------------------------------
    # solr fields to be displayed in the show (single result) view
    # The ordering of the field names is the order of the display
    # None of these fields apply to ead documents or components
    config.add_show_field solr_name("title",        :displayable),  :label => "Title", 
                                                                    :highlight => true,
                                                                    :itemprop => "name"

    config.add_show_field solr_name("unititle",     :displayable),  :label => "Uniform Title",
                                                                    :itemprop => "alternateName"
                                                                    
    config.add_show_field solr_name("title_addl",   :displayable),  :label => "Additional Titles",
                                                                    :itemprop => "alternativeHeadline"

    config.add_show_field solr_name("author",       :displayable),  :label          => "Author",
                                                                    :helper_method  => :render_facet_link,
                                                                    :facet          => solr_name("name", :facetable),
                                                                    :highlight      => true,
                                                                    :itemprop       => "author"

    config.add_show_field solr_name("edition",      :displayable),  :label => "Edition", :itemprop => "bookEdition"

    config.add_show_field solr_name("series",       :displayable),  :label          => "Series",
                                                                    :helper_method  => :render_facet_link,
                                                                    :facet          => solr_name("series", :facetable)

    config.add_show_field solr_name("format",       :displayable),  :label => "Format"
    config.add_show_field solr_name("format_dtl",   :displayable),  :label => "Format Details"
    config.add_show_field solr_name("unitdate",     :displayable),  :label => "Dates"

    config.add_show_field solr_name("ohlink_url",   :displayable), :label           => "OhioLink Resource",
                                                                   :helper_method   => :render_external_link, 
                                                                   :text            => solr_name("ohlink_text", :displayable)
    
    config.add_show_field solr_name("resource_url", :displayable), :label           => "Online Resource",     
                                                                   :helper_method   => :render_external_link, 
                                                                   :text            => solr_name("resource_text", :displayable)
    
    config.add_show_field solr_name("physical_dtl", :displayable),  :label => "Physical Details"
    config.add_show_field solr_name("summary",      :displayable),  :label => "Summary",
                                                                    :itemprop => "description"

    config.add_show_field solr_name("participants", :displayable),  :label => "Participants"
    config.add_show_field solr_name("recinfo",      :displayable),  :label => "Recording Info"
    config.add_show_field solr_name("contents",     :displayable),  :label => "Contents"
    config.add_show_field solr_name("donor",        :displayable),  :label => "Donor"

    config.add_show_field solr_name("collection",   :displayable),  :label         => "Archival Collection", 
                                                                    :helper_method => :render_facet_link,
                                                                    :facet         => solr_name("collection", :facetable),
                                                                    :highlight     => true
    
    config.add_show_field solr_name("access",       :displayable),  :label => "Access"

    config.add_show_field solr_name("subject",      :displayable),  :label         => "Subjects",
                                                                    :helper_method => :render_subjects

    config.add_show_field solr_name("genre",        :displayable),  :label         => "Genre/Form",
                                                                    :helper_method => :render_facet_link,
                                                                    :facet         => solr_name("genre", :facetable),
                                                                    :itemprop      => "genre"

    config.add_show_field solr_name("contributors", :displayable),  :label         => "Contributors",
                                                                    :helper_method => :render_facet_link,
                                                                    :facet         => solr_name("name", :facetable),
                                                                    :itemprop      => "contributor"

    config.add_show_field solr_name("relworks",     :displayable),  :label         => "Related Works",
                                                                    :helper_method => :render_search_link

    config.add_show_field solr_name("relitems",     :displayable),  :label => "Related Items"
    config.add_show_field solr_name("item_link",    :displayable),  :label => "Item Links"
    config.add_show_field solr_name("pub_date",     :displayable),  :label => "Dates of Publication"
    config.add_show_field solr_name("freq",         :displayable),  :label => "Current Frequency"
    config.add_show_field solr_name("freq_former",  :displayable),  :label => "Former Frequency"
    config.add_show_field solr_name("language",     :displayable),  :label => "Language"

    config.add_show_field solr_name("publisher",    :displayable),  :label      => "Publisher",
                                                                    :highlight  => true

    config.add_show_field solr_name("lc_callnum",   :displayable),  :label => "Call Number"
    config.add_show_field solr_name("isbn",         :displayable),  :label => "ISBN", :itemprop => "isbn"
    config.add_show_field solr_name("issn",         :displayable),  :label => "ISSN"
    config.add_show_field solr_name("upc",          :displayable),  :label => "UPC"
    config.add_show_field solr_name("pubnum",       :displayable),  :label => "Publisher Number"
    config.add_show_field solr_name("oclc",         :displayable),  :label => "OCLC No"
 
    # Fields specific to ead components
    config.add_show_field solr_name("scopecontent",      :displayable), :label => "Scope and Contents", :itemprop => "description"
    config.add_show_field solr_name("separatedmaterial", :displayable), :label => "Separated Material"
    config.add_show_field solr_name("accessrestrict",    :displayable), :label => "Access Restrictions"
    config.add_show_field solr_name("accruals",          :displayable), :label => "Accruals"
    config.add_show_field solr_name("acqinfo",           :displayable), :label => "Acquistions"
    config.add_show_field solr_name("altformavail",      :displayable), :label => "Alt. Form"
    config.add_show_field solr_name("appraisal",         :displayable), :label => "Appraisal"
    config.add_show_field solr_name("arrangement",       :displayable), :label => "Arrangement"
    config.add_show_field solr_name("custodhist",        :displayable), :label => "Custodial History"
    config.add_show_field solr_name("fileplan",          :displayable), :label => "File Plan"
    config.add_show_field solr_name("originalsloc",      :displayable), :label => "Originals"
    config.add_show_field solr_name("phystech",          :displayable), :label => "Physical Tech"
    config.add_show_field solr_name("processinfo",       :displayable), :label => "Processing"
    config.add_show_field solr_name("relatedmaterial",   :displayable), :label => "Related Material"
    config.add_show_field solr_name("userestrict",       :displayable), :label => "Usage Restrictions"
    config.add_show_field solr_name("physdesc",          :displayable), :label => "Physical Description"
    config.add_show_field solr_name("langmaterial",      :displayable), :label => "Language"
    config.add_show_field solr_name("note",              :displayable), :label => "Notes"
    config.add_show_field solr_name("accession",         :displayable), :label => "Accession Numbers"
    config.add_show_field solr_name("print_run",         :displayable), :label => "Limited Print Run"
    config.add_show_field solr_name("dimensions",        :displayable), :label => "Dimensions"

    config.add_show_field solr_name("location",          :displayable), :label     => "Container",
                                                                        :highlight => true

    config.add_show_field solr_name("material",          :displayable), :label          => "Archival Material",
                                                                        :highlight      => true
    
    config.add_show_field solr_name("shelf",             :displayable), :label => "Location"

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field "all_fields", :label => "All Fields"


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field("title") do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => "title" }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        :qf => "$title_qf",
        :pf => "$title_pf"
      }
    end

    config.add_search_field("name") do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => "name" }
      field.solr_local_parameters = {
        :qf => "$name_qf",
        :pf => "$name_pf"
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field("subject") do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => "subject" }
      field.qt = "search"
      field.solr_local_parameters = {
        :qf => "$subject_qf",
        :pf => "$subject_pf"
      }
    end

    # OCLC search
    config.add_search_field("OCLC No.") do |field|
      field.qt = "search"
      field.solr_local_parameters = {
        :qf => "$oclc_qf",
        :pf => "$oclc_pf"
      }
    end

    # Call number search
    config.add_search_field("Call No.") do |field|
      field.qt = "search"
      field.solr_local_parameters = {
        :qf => "$call_qf",
        :pf => "$call_pf"
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field "score desc, title_si asc, pub_date_si desc", :label => "relevance"
    config.add_sort_field "pub_date_si desc, title_si asc",             :label => "year"
    config.add_sort_field "author_si asc, title_si asc",                :label => "author"
    config.add_sort_field "title_si asc",                               :label => "title"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end
