puts "WARNING: rockhall_config.rb is deprecated and must be re-written"

Blacklight.configure(:shared) do |config|

  # These are fields that will appear as links in the results page.
  # It can be either a field search or a facet, but not both.
  # For searchers, the value of the :search key indicates the search type as defined below
  # in config[:search_types]
  # For facets, the value of the :facet key is the facet field that the term should link to
  config[:linked_fields] = {
    :subject_display => {
      :search => FALSE,
      :facet  => "subject_topic_facet",
    },
    :genre_display => {
      :search => FALSE,
      :facet  => "genre_facet",
    },
    :contributors_display => {
      :search => FALSE,
      :facet  => "name_facet",
    },
    :series_display => {
      :search => FALSE,
      :facet  => "series_facet",
    },
    :relworks_display => {
      :search => "all_fields",
      :facet  => FALSE,
    },
    :collection_display => {
      :search => "all_fields",
      :facet  => FALSE,
    },
  }

  # Fields that link to external sites
  config[:external_links] = {
    "resource_link_display" => "title_display"
  }

  # EAD config
  # Important! Any changes below will require you to reindex all your EAD documents
  # Only fields with a given label will appear under the "General Information"
  # section of the display.  Otherwise, field names will need to be called directly
  # in the view.
  config[:ead_dir]            = "test/data/ead"
  config[:ead_format_name]    = "Archival Collection"
  config[:ead_component_name] = "Archival Item"


  # EAD document fields
  # These are fields in the /ead section of the xml
  # and exclude anything in a component or //c0n node
  config[:ead_fields] = {
    :title_display => {
      :xpath      => "/ead/archdesc/did/unittitle",
      :label      => "Title",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :title_t => {
      :xpath      => "/ead/archdesc/did/unittitle",
      :label      => nil,
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :title_addl_t => {
      :xpath      => "/ead/archdesc/did/unittitle",
      :label      => nil,
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :collection_display => {
      :xpath      => "/ead/archdesc/did/unittitle",
      :label      => nil,
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :collection_facet => {
      :xpath      => "/ead/archdesc/did/unittitle",
      :label      => nil,
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :extent_display => {
      :xpath      => "/ead/archdesc/did/physdesc/extent",
      :label      => "Extent",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :bulk_date_display => {
      :xpath      => "/ead/archdesc/did/unitdate[@type='bulk']",
      :label      => "Dates",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :inc_date_display => {
      :xpath      => "/ead/archdesc/did/unitdate[@type='inclusive']",
      :label      => "Dates",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :date_display => {
      :xpath      => "/ead/archdesc/did/unitdate[not(@type)]",
      :label      => "Dates",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :aid_language_display => {
      :xpath      => "/ead/eadheader/profiledesc/langusage",
      :label      => "Language of Finding Aid",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :language_display => {
      :xpath      => "/ead/archdesc/did/langmaterial",
      :label      => "Language of Materials",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :abstract_display => {
      :xpath      => "/ead/archdesc/did/abstract",
      :label      => "Collection Overview",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :bio_display => {
      :xpath      => "/ead/archdesc/bioghist/p",
      :label      => "/ead/archdesc/bioghist/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :sepmaterial_display => {
      :xpath      => "/ead/archdesc/separatedmaterial/p",
      :label      => "/ead/archdesc/separatedmaterial/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :relitems_display => {
      :xpath      => "/ead/archdesc/relatedmaterial/p",
      :label      => "/ead/archdesc/relatedmaterial/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :accruals_display => {
      :xpath      => "/ead/archdesc/accruals/p",
      :label      => "Accruals",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :citation_display => {
      :xpath      => "/ead/archdesc/prefercite/p",
      :label      => "/ead/archdesc/prefercite/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :provenance_display => {
      :xpath      => "/ead/archdesc/custodhist/p",
      :label      => "Custodial History",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :usage_display => {
      :xpath      => "/ead/archdesc/userestrict/p",
      :label      => "/ead/archdesc/userestrict/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :access_display => {
      :xpath      => "/ead/archdesc/accessrestrict/p",
      :label      => "/ead/archdesc/accessrestrict/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :process_display => {
      :xpath      => "/ead/archdesc/processinfo/p",
      :label      => "Processing Information",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
  }


  # EAD component fields
  # Fields found in component //c0n nodes where n is a number from 1 to 6
  config[:component_fields] = {
    :title_display => {
      :xpath      => "did/unittitle",
      :label      => "Title",
      :is_xpath   => FALSE,
      :formatted  => TRUE
    },
    :unitdate_display => {
      :xpath      => "did/unitdate",
      :label      => "Date",
      :is_xpath   => FALSE,
      :formatted  => FALSE,
    },
    :physdesc_display  => {
      :xpath      => "did/physdesc[not(dimensions)]",
      :label      => "Physical Description",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :odd_display  => {
      :xpath      => "odd/p",
      :label      => "odd/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :contents_display  => {
      :xpath      => "scopecontent/p",
      :label      => "Scope and Contents",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :access_display  => {
      :xpath      => "accessrestrict/p",
      :label      => "Access Restrictions",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :processinfo_display  => {
      :xpath      => "processinfo/p",
      :label      => "Processing Information",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :separatedmaterial_display  => {
      :xpath      => "separatedmaterial/p",
      :label      => "Separated Materials",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :originalsloc_display  => {
      :xpath      => "originalsloc/p",
      :label      => "Existence and Location of Originals",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :phystech_display  => {
      :xpath      => "phystech/p",
      :label      => "Phystech (Field name needed)",
      :is_xpath   => FALSE,
      :formatted  => FALSE,
    },
    :altformavail_display  => {
      :xpath      => "altformavail/p",
      :label      => "altformavail/head",
      :is_xpath   => TRUE,
      :formatted  => FALSE,
    },
    :userestrict_display  => {
      :xpath      => "userestrict/p",
      :label      => "Use Restrictions",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :bioghist_display  => {
      :xpath      => "bioghist/p",
      :label      => "Biographical Note",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :langmaterial_display => {
      :xpath      => "did/langmaterial",
      :label      => "Language of Materials",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
    :acqinfo_display => {
      :xpath      => "acqinfo/p",
      :label      => "acqinfo/head",
      :is_xpath   => TRUE,
      :formatted  => TRUE,
    },
    :dimensions_display => {
      :xpath      => "did/physdesc/dimensions",
      :label      => "Dimensions",
      :is_xpath   => FALSE,
      :formatted  => TRUE,
    },
  }


  config[:ead_headings] = [
    "abstract_display",
    "bio_display",
    "relitems_display",
    "sepmaterial_display",
    "accruals_display",
  ]

  config[:ead_geninfo]  = [
    "title_display",
    "extent_display",
    "bulk_date_display",
    "inc_date_display",
    "date_display",
    "aid_language_display",
    "language_display",
    "citation_display",
    "provenance_display",
    "usage_display",
    "access_display",
    "process_display",
  ]

  # Optional EAD things
  config[:ead_display_title_preface] = "Guide to the"
  config[:ead_component_title_separator] = " > "

end