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

  def render_front_page_account_tools
    if current_user
      render "shared/front_page_account_tools" if has_user_authentication_provider?
    else
      link_to t("account_login"), new_user_session_path, :class => "btn btn-primary search-btn",
              :data => { :toggle => "tooltip", :placement => "bottom" },
              :title => t("tooltip.account_login")
    end
  end

  def search_form_class
    if front_page?
      "form front-search"
    else
      "navbar-form navbar-left"
    end
  end

  def search_form_id
    if front_page?
      "front_page_search"
    else
      "search_bar"
    end
  end

  def search_form_button_class
    if front_page?
      "btn btn-primary search-btn"
    else
      "btn search-btn"
    end
  end

  def front_page?
    params[:controller].match("catalog") && params[:action].match("index") && !has_search_parameters?
  end

  def show_facet_toggle?
    params[:action].match("index") && params[:controller].match("catalog")
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
