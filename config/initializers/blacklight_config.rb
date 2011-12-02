# You can configure Blacklight from here.
#
#   Blacklight.configure(:environment) do |config| end
#
# :shared (or leave it blank) is used by all environments.
# You can override a shared key by using that key in a particular
# environment's configuration.
#
# If you have no configuration beyond :shared for an environment, you
# do not need to call configure() for that envirnoment.
#
# For specific environments:
#
#   Blacklight.configure(:test) {}
#   Blacklight.configure(:development) {}
#   Blacklight.configure(:production) {}
#

Blacklight.configure(:shared) do |config|

  config[:default_solr_params] = {
    :qt       => "search",
    :per_page => 10
  }

  # solr field values given special treatment in the show (single result) view
  config[:show] = {
    :html_title   => "title_display",
    :heading      => "title_display",
    :display_type => "format"
  }

  # solr fld values given special treatment in the index (search results) view
  config[:index] = {
    :show_link            => "heading_display",
    :record_display_type  => "format"
  }

  # solr fields that will be treated as facets by the blacklight application
  #   The ordering of the field names is the order of the display
  # TODO: Reorganize facet data structures supplied in config to make simpler
  # for human reading/writing, kind of like search_fields. Eg,
  # config[:facet] << {:field_name => "format", :label => "Format", :limit => 10}
  config[:facet] = {
    :field_names => (facet_fields = [
      "format",
      "collection_facet",
      "material_facet",
      "pub_date",
      "topic_facet",
      "name_facet",
      "series_facet",
      "language_facet",
      "lc_1letter_facet",
      "genre_facet"
    ]),
    :labels => {
      "format"              => "Format",
      "collection_facet"    => "Collection Name",
      "material_facet"      => "Archival Material",
      "pub_date"            => "Publication Year",
      "topic_facet"         => "Topic",
      "name_facet"          => "Name",
      "series_facet"        => "Event/Series",
      "language_facet"      => "Language",
      "lc_1letter_facet"    => "Call Number",
      "genre_facet"         => "Genre"
    },
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
    :limits => {
      "format"              => 10,
      "material_facet"      => 10,
      "collection_facet"    => 10,
      "pub_date"            => 10,
      "topic_facet"         => 10,
      "name_facet"          => 10,
      "series_facet"        => 10,
      "language_facet"      => true,
      "lc_1letter_facet"    => 10,
      "genre_facet"         => 10

    }
  }

  # Have BL send all facet field names to Solr, which has been the default
  # previously. Simply remove these lines if you'd rather use Solr request
  # handler defaults, or have no facets.
  config[:default_solr_params] ||= {}
  config[:default_solr_params][:"facet.field"] = facet_fields

  # solr fields to be displayed in the index (search results) view
  #   The ordering of the field names is the order of the display
  config[:index_fields] = {
    :field_names => [
      "title_display",
      "author_display",
      "format",
      "language_display",
      "publisher_display",
      "lc_callnum_display",
      #"innovative_display",
      # EAD-only fields
      "unitdate_display",
      "collection_display",
      "parent_unittitle_list",
      "location_display"
    ],
    :labels => {
      "title_display"           => "Title:",
      "author_display"          => "Author:",
      "format"                  => "Format:",
      "language_display"        => "Language:",
      "publisher_display"       => "Publisher:",
      "lc_callnum_display"      => "Call Number:",
      #"innovative_display"      => "Status:",
      # EAD-only fields
      "unitdate_display"        => "Dates:",
      "collection_display"      => "Archival Collection:",
      "parent_unittitle_list"   => "Series:",
      "location_display"        => "Location:"
    }
  }


  # solr fields to be displayed in the show (single result) view
  #   The ordering of the field names is the order of the display
  config[:show_fields] = {
    :field_names => [
      "title_display",
      "unititle_display",
      "title_addl_display",
      "author_display",
      "edition_display",
      "series_display",
      "format",
      "format_dtl_display",
      "physical_dtl_display",
      "summary_display",
      "participants_display",
      "recinfo_display",
      "contents_display",
      "notes_display",
      "donor_display",
      "collection_display",
      "access_display",
      "subject_display",
      "genre_display",
      "contributors_display",
      "relworks_display",
      "relitems_display",
      "item_link_display",
      "oh_link_display",
      "resource_link_display",
      "pub_date_display",
      "freq_display",
      "freq_former_display",
      "language_display",
      "publisher_display",
      "lc_callnum_display",
      "isbn_t",
      "issn_display",
      "upc_display",
      "pubnum_display",
      # EAD-only fields
      "arcsource_display",
      "unitdate_display",
      "accessrestrict_display",
      "processinfo_display",
      "location_display"
    ],
    :labels => {
      "title_display"           => "Title:",
      "unititle_display"        => "Uniform Title:",
      "title_addl_display"      => "Additional Titles:",
      "author_display"          => "Author:",
      "edition_display"         => "Edition:",
      "series_display"          => "Series:",
      "format"                  => "Format:",
      "format_dtl_display"      => "Format Details:",
      "physical_dtl_display"    => "Physical Details:",
      "summary_display"         => "Summary:",
      "participants_display"    => "Participants:",
      "recinfo_display"         => "Recording Info:",
      "contents_display"        => "Contents:",
      "notes_display"           => "Notes:",
      "donor_display"           => "Donor:",
      "collection_display"      => "Archival Collection:",
      "access_display"          => "Access:",
      "subject_display"         => "Subjects:",
      "genre_display"           => "Genre/Form:",
      "contributors_display"    => "Contributors:",
      "relworks_display"        => "Related Works:",
      "relitems_display"        => "Related Items:",
      "item_link_display"       => "Item Links:",
      "oh_link_display"         => "OhioLink:",
      "resource_link_display"   => "Resource Link:",
      "pub_date_display"        => "Dates of Publication:",
      "freq_display"            => "Current Frequency:",
      "freq_former_display"     => "Former Frequency:",
      "language_display"        => "Language:",
      "publisher_display"       => "Publisher:",
      "lc_callnum_display"      => "Call Number:",
      "isbn_t"                  => "ISBN:",
      "issn_display"            => "ISSN:",
      "upc_display"             => "UPC:",
      "pubnum_display"          => "Publisher Number:",
      # EAD-only fields
      "arcsource_display"       => "Archive Source:",
      "unitdate_display"        => "Unit Date:",
      "accessrestrict_display"  => "Access Restrictions:",
      "processinfo_display"     => "Process Info:",
      "location_display"        => "Location:"
    }
  }

  # These are fields that will appear as links in the results page.
  # Value of each key indicates the search type as defined below
  # in config[:search_types]
  config[:linked_fields] = {
    :subject_display       => "all_fields",
    :genre_display         => "all_fields",
    :contributors_display  => "all_fields",
    :relworks_display      => "all_fields",
    :collection_display    => "all_fields",
  }

  # Fields that link to external sites
  config[:external_links] = {
    "resource_link_display" => "title_display"
  }


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
  config[:search_fields] ||= []

  # This one uses all the defaults set by the solr request handler. Which
  # solr request handler? The one set in config[:default_solr_parameters][:qt],
  # since we aren't specifying it otherwise.
  config[:search_fields] << {
    :key => "all_fields",
    :display_label => 'All Fields'
  }

  # Now we see how to over-ride Solr request handler defaults, in this
  # case for a BL "search field", which is really a dismax aggregate
  # of Solr search fields.
  config[:search_fields] << {
    :key => 'title',
    # solr_parameters hash are sent to Solr as ordinary url query params.
    :solr_parameters => {
      :"spellcheck.dictionary" => "title"
    },
    # :solr_local_parameters will be sent using Solr LocalParams
    # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    # Solr parameter de-referencing like $title_qf.
    # See: http://wiki.apache.org/solr/LocalParams
    :solr_local_parameters => {
      :qf => "$title_qf",
      :pf => "$title_pf"
    }
  }
  config[:search_fields] << {
    :key =>'author',
    :solr_parameters => {
      :"spellcheck.dictionary" => "author"
    },
    :solr_local_parameters => {
      :qf => "$author_qf",
      :pf => "$author_pf"
    }
  }

  # Specifying a :qt only to show it's possible, and so our internal automated
  # tests can test it. In this case it's the same as
  # config[:default_solr_parameters][:qt], so isn't actually neccesary.
  config[:search_fields] << {
    :key => 'subject',
    :qt=> 'search',
    :solr_parameters => {
      :"spellcheck.dictionary" => "subject"
    },
    :solr_local_parameters => {
      :qf => "$subject_qf",
      :pf => "$subject_pf"
    }
  }

  # Contributor search
  config[:search_fields] << {
    :key => 'contributor',
    :qt=> 'search',
    :solr_local_parameters => {
      :f => "$contributors_qf"
    }
  }


  # "sort results by" select (pulldown)
  # label in pulldown is followed by the name of the SOLR field to sort by and
  # whether the sort is ascending or descending (it must be asc or desc
  # except in the relevancy case).
  # label is key, solr field is value
  config[:sort_fields] ||= []
  config[:sort_fields] << ['relevance', 'score desc, pub_date_sort desc, title_sort asc']
  config[:sort_fields] << ['year', 'pub_date_sort desc, title_sort asc']
  config[:sort_fields] << ['author', 'author_sort asc, title_sort asc']
  config[:sort_fields] << ['title', 'title_sort asc, pub_date_sort desc']
  config[:sort_fields] << ['format', 'format asc']

  # If there are more than this many search results, no spelling ("did you
  # mean") suggestion is offered.
  config[:spell_max] = 5

  # Add documents to the list of object formats that are supported for all objects.
  # This parameter is a hash, identical to the Blacklight::Solr::Document#export_formats
  # output; keys are format short-names that can be exported. Hash includes:
  #    :content-type => mime-content-type
  config[:unapi] = {
    'oai_dc_xml' => { :content_type => 'text/xml' }
  }

  # EAD config
  # Important! Any changes below will require you to reindex all your EAD documents
  # Only fields with a given label will appear under the "General Information"
  # section of the display.  Otherwise, field names will need to be called directly
  # in the view.
  config[:ead_dir]            = "test/data/ead"
  config[:ead_format_name]    = "Archival Collection"
  config[:ead_component_name] = "Archival Item"

  config[:ead_fields] = {
    :ead_title_display => {
      :xpath      => "/ead/archdesc/did/unittitle",
      :label      => "Title",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_repository_display => {
      :xpath      => "/ead/archdesc/did/repository/corpname",
      :label      => "Repository",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_publisher_display => {
      :xpath      => "/ead/eadheader/filedesc/publicationstmt/address/addressline",
      :label      => "Publisher",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_extent_display => {
      :xpath      => "/ead/archdesc/did/physdesc/extent",
      :label      => "Extent",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_bulk_date_display => {
      :xpath      => "/ead/archdesc/did/unitdate[@type='bulk']",
      :label      => "Bulk Date",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_inc_date_display => {
      :xpath      => "/ead/archdesc/did/unitdate[@type='inclusive']",
      :label      => "Inclusive Dates",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_lang_display => {
      :xpath      => "/ead/eadheader/profiledesc/langusage",
      :label      => "Language of Finding Aid",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_lang_coll_display => {
      :xpath      => "/ead/archdesc/did/langmaterial",
      :label      => "Language of Materials",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_abstract_display => {
      :xpath      => "/ead/archdesc/did/abstract",
      :label      => "Collection Overview",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :ead_bio_display => {
      :xpath      => "/ead/archdesc/bioghist/p",
      :label      => "/ead/archdesc/bioghist/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_sepmaterial_display => {
      :xpath      => "/ead/archdesc/separatedmaterial/p",
      :label      => "/ead/archdesc/separatedmaterial/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_relatedmaterial_display => {
      :xpath      => "/ead/archdesc/relatedmaterial/p",
      :label      => "/ead/archdesc/relatedmaterial/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_accruals_display => {
      :xpath      => "/ead/archdesc/accruals/p",
      :label      => "/ead/archdesc/accruals/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_citation_display => {
      :xpath      => "/ead/archdesc/prefercite/p",
      :label      => "/ead/archdesc/prefercite/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_provenance_display => {
      :xpath      => "/ead/archdesc/acqinfo/p",
      :label      => "/ead/archdesc/acqinfo/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_use_display => {
      :xpath      => "/ead/archdesc/userestrict/p",
      :label      => "/ead/archdesc/userestrict/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_access_display => {
      :xpath      => "/ead/archdesc/accessrestrict/p",
      :label      => "/ead/archdesc/accessrestrict/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :ead_process_display => {
      :xpath      => "/ead/archdesc/processinfo/p",
      :label      => "/ead/archdesc/processinfo/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :c_title_display => {
      :xpath      => "did/unittitle",
      :formatted  => TRUE
    },
    :unitdate_display => {
      :xpath      => "did/unitdate",
      :formatted  => FALSE
    },
    :physdesc_display  => {
      :xpath      => "did/physdesc",
      :formatted  => TRUE
    },
    :odd_display  => {
      :xpath      => "odd/p",
      :formatted  => TRUE
    },
    :odd_label_display  => {
      :xpath      => "odd/head",
      :formatted  => FALSE
    },
    :scopecontent_display  => {
      :xpath      => "scopecontent/p",
      :formatted  => TRUE
    },
    :accessrestrict_display  => {
      :xpath      => "accessrestrict/p",
      :formatted  => TRUE
    },
    :processinfo_display  => {
      :xpath      => "processinfo/p",
      :formatted  => TRUE
    },
    :separatedmaterial_display  => {
      :xpath      => "separatedmaterial/p",
      :formatted  => TRUE
    },
    :originalsloc_display  => {
      :xpath      => "originalsloc/p",
      :formatted  => TRUE
    },
    :phystech_display  => {
      :xpath      => "phystech/p",
      :formatted  => FALSE
    },
    :altformavail_display  => {
      :xpath      => "altformavail/p",
      :formatted  => FALSE
    },
    :userestrict_display  => {
      :xpath      => "userestrict/p",
      :formatted  => TRUE
    },
    :bioghist_display  => {
      :xpath      => "bioghist/p",
      :formatted  => TRUE
    },
    :originalsloc_display => {
      :xpath      => "originalsloc/p",
      :formatted  => TRUE
    },
    :langmaterial_display => {
      :xpath      => "did/langmaterial",
      :formatted  => FALSE
    },
  }

  config[:ead_headings] = [
    "ead_abstract_display",
    "ead_bio_display",
    "ead_sepmaterial_display",
    "ead_relatedmaterial_display",
    "ead_accruals_display",
    "ead_citation_display",
    "ead_provenance_display",
    "ead_use_display",
    "ead_access_display",
    "ead_process_display"
  ]
  config[:ead_geninfo]  = [
    "ead_title_display",
    "ead_repository_display",
    "ead_publisher_display",
    "ead_extent_display",
    "ead_bulk_date_display",
    "ead_inc_date_display",
    "ead_lang_display",
    "ead_lang_coll_display"
  ]
  config[:component_fields] = [
    "c_title_display",
    "unitdate_display",
    "physdesc_display",
    "odd_display",
    "odd_label_display",
    "scopecontent_display",
    "accessrestrict_display",
    "processinfo_display",
    "separatedmaterial_display",
    "originalsloc_display",
    "phystech_display",
    "altformavail_display",
    "userestrict_display",
    "bioghist_display",
    "originalsloc_display",
    "langmaterial_display",

  ]

  # Optional EAD things
  config[:ead_display_title_preface] = "Guide to the"
  config[:ead_component_title_separator] = ">>"

  config[:opac_ip] = "129.22.104.30"
end

