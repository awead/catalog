module ApplicationHelper

  def render_index_response
    if @response.empty?
      render "zero_results"
    elsif render_grouped_response?
      render_grouped_document_index
    else
      render_document_index
    end
  end

  def render_header
    if front_page?
      render "shared/header"
    else
      render "shared/navbar"
    end
  end

  def render_front_page_search_form
    render "shared/front_page_search" if front_page?
  end

  def front_page?
    params[:controller].match("catalog") && params[:action].match("index") && !has_search_parameters?
  end

  def render_facets
    render "catalog/facets"
  end

  # COinS, for Zotero among others. 
  # This document_partial_name(@document) business is not quite right, but has been there for a while. 
  def render_z3988_title
    if @document.respond_to?(:export_as_openurl_ctx_kev)
      content_tag :span, nil, :class => "Z3988", :title => @document.export_as_openurl_ctx_kev(document_partial_name(@document))
    end
  end

  def document_dom_id
    "doc_" + @document.id.to_s.parameterize
  end

  def field_diplay_class solr_fname
    "blacklight-"+solr_fname.parameterize
  end

  def suggest_searching_everything
    if params[:q] and params[:search_field] and params[:search_field] != blacklight_config.default_search_field
      content_tag :li do
        t("blacklight.search.zero_results.search_fields", :search_fields => search_field_label(params))
        link_to t("blacklight.search.zero_results.search_everything"), url_for(params_for_search(:search_field=>blacklight_config.default_search_field.key))
      end
    end
  end

  def see_everything_in_collection
    if params["f"][Solrizer.solr_name("collection", :facetable)]
      content_tag :li, collection_facet_link(t("zero_results.see_collection"))
    end
  end

end
