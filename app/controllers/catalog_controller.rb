# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog
  include BlacklightHighlight::ControllerExtension
  include Rockhall::EadSolrMethods

  configure_blacklight do |config|
    config.default_solr_params = {
      :qt => 'search',
      :rows => 10,
      ("hl.fl").to_sym => "title_display,author_display,publisher_display,collection_display,parent_unittitle_list,location_display"
    }

    # solr field configuration for search results/index views
    config.index.show_link = 'heading_display'
    config.index.record_display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = 'heading_display'
    config.show.heading = 'heading_display'
    config.show.display_type = 'format'

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
    config.add_facet_field 'format',              :label => 'Format',             :limit => 20
    config.add_facet_field 'collection_facet',    :label => 'Collection Name',    :limit => 20
    config.add_facet_field 'material_facet',      :label => 'Archival Material',  :limit => 20
    config.add_facet_field 'pub_date',            :label => 'Publication Year',   :limit => 20
    config.add_facet_field 'subject_topic_facet', :label => 'Topic',              :limit => 20
    config.add_facet_field 'name_facet',          :label => 'Name',               :limit => 20
    config.add_facet_field 'series_facet',        :label => 'Event/Series',       :limit => 20
    config.add_facet_field 'language_facet',      :label => 'Language',           :limit => true
    config.add_facet_field 'genre_facet',         :label => 'Genre',              :limit => 20

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys

    
    # ------------------------------------------------------------------------------------------
    #
    # Index view fields
    #
    # ------------------------------------------------------------------------------------------
    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'title_display',         :label => 'Title:'
    config.add_index_field 'author_display',        :label => 'Author:', :helper_method => :render_facet_link
    config.add_index_field 'format',                :label => 'Format:'

    # Links to external resources. N.B. Text for link is definein the add_show_field method
    config.add_index_field 'ohlink_url_display',    :label => 'OhioLink Resource:', :helper_method => :render_external_link
    config.add_index_field 'resource_url_display',  :label => 'Online Resource:',   :helper_method => :render_external_link

    config.add_index_field 'language_language',     :label => 'Language:'
    config.add_index_field 'publisher_display',     :label => 'Publisher:'
    config.add_index_field 'lc_callnum_display',    :label => 'Call Number:'
    config.add_index_field 'unitdate_display',      :label => 'Dates:'
    
    # N.B. Facet field is defined in add_show_field below
    config.add_index_field 'collection_display',    :label => 'Archival Collection:', :helper_method => :render_facet_link

    config.add_index_field 'parent_unittitle_list', :label => 'Series:'
    config.add_index_field 'location_display',      :label => 'Location:'


    # ------------------------------------------------------------------------------------------
    #
    # Show view fields (individual record)
    #
    # ------------------------------------------------------------------------------------------
    # solr fields to be displayed in the show (single result) view
    # The ordering of the field names is the order of the display
    # None of these fields apply to ead documents or components
    config.add_show_field "title_display",        :label => 'Title:'
    config.add_show_field 'unititle_display',     :label => 'Uniform Title:'
    config.add_show_field 'title_addl_display',   :label => 'Additional Titles:'

    config.add_show_field 'author_display',       :label         => 'Author:',
                                                  :helper_method => :render_facet_link,
                                                  :facet         => 'name_facet'

    config.add_show_field 'edition_display',      :label => 'Edition:'

    config.add_show_field 'series_display',       :label         => 'Series:',
                                                  :helper_method => :render_facet_link,
                                                  :facet         => 'series_facet'
    

    config.add_show_field 'format',               :label => 'Format:'
    config.add_show_field 'format_dtl_display',   :label => 'Format Details:'

    # Links to external resources
    config.add_show_field 'ohlink_url_display',   :label         => 'OhioLink Resource:',
                                                  :helper_method => :render_external_link, 
                                                  :text          => 'ohlink_text_display'
    
    config.add_show_field 'resource_url_display', :label         => 'Online Resource:',     
                                                  :helper_method => :render_external_link, 
                                                  :text          => 'resource_text_display'
    
    config.add_show_field 'physical_dtl_display', :label => 'Physical Details:'
    config.add_show_field 'summary_display',      :label => 'Summary:'
    config.add_show_field 'participants_display', :label => 'Participants:'
    config.add_show_field 'recinfo_display',      :label => 'Recording Info:'
    config.add_show_field 'contents_display',     :label => 'Contents:'
    config.add_show_field 'notes_display',        :label => 'Notes:'
    config.add_show_field 'donor_display',        :label => 'Donor:'

    config.add_show_field 'collection_display',   :label         => 'Archival Collection:', 
                                                  :helper_method => :render_facet_link,
                                                  :facet         => 'collection_facet'
    
    config.add_show_field 'access_display',       :label => 'Access:'

    config.add_show_field 'subject_display',      :label         => 'Subjects:',
                                                  :helper_method => :render_facet_link,
                                                  :facet         => 'subject_topic_facet'

    config.add_show_field 'genre_display',        :label         => 'Genre/Form:',
                                                  :helper_method => :render_facet_link,
                                                  :facet         => 'genre_facet'

    config.add_show_field 'contributors_display', :label         => 'Contributors:',
                                                  :helper_method => :render_facet_link,
                                                  :facet         => 'name_facet'

    config.add_show_field 'relworks_display',     :label         => 'Related Works:',
                                                  :helper_method => :render_search_link

    config.add_show_field 'relitems_display',     :label => 'Related Items:'
    config.add_show_field 'item_link_display',    :label => 'Item Links:'
    config.add_show_field 'pub_date_display',     :label => 'Dates of Publication:'
    config.add_show_field 'freq_display',         :label => 'Current Frequency:'
    config.add_show_field 'freq_former_display',  :label => 'Former Frequency:'
    config.add_show_field 'language_display',     :label => 'Language:'
    config.add_show_field 'publisher_display',    :label => 'Publisher:'
    config.add_show_field 'lc_callnum_display',   :label => 'Call Number:'
    config.add_show_field 'isbn_t',               :label => 'ISBN:'
    config.add_show_field 'issn_display',         :label => 'ISSN:'
    config.add_show_field 'upc_display',          :label => 'UPC:'
    config.add_show_field 'pubnum_display',       :label => 'Publisher Number:'
    config.add_show_field 'id',                   :label => 'OCLC No.:'

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

    config.add_search_field 'all_fields', :label => 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end

    config.add_search_field('name') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'name' }
      field.solr_local_parameters = {
        :qf => '$name_qf',
        :pf => '$name_pf'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = {
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # OCLC search
    config.add_search_field('OCLC No.') do |field|
      field.qt = 'search'
      field.solr_local_parameters = {
        :qf => "$oclc_qf",
        :pf => "$oclc_pf"
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, title_sort asc, pub_date_sort desc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, title_sort asc',             :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc',                :label => 'author'
    config.add_sort_field 'title_sort asc',                                 :label => 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  def show
    ead_id = get_field_from_solr("ead_id",params[:id])
    if ead_id.nil?
      super
    else

      @components = Hash.new
      @components[:first] = get_component_docs_from_solr(ead_id,{ :level => "1"})
      parent_ref_list = get_field_from_solr("parent_ref_list",params[:id])
      unless parent_ref_list.nil?
        parent_ref_list.each do |ref|
          @components[ref.to_sym] = get_component_docs_from_solr(ead_id,{ :parent_ref => ref.to_s})
        end
      end

      params[:solr_id] = params[:id]
      params[:id] = ead_id
      super

    end
  end

end
