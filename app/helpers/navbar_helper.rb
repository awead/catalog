module NavbarHelper

  def render_login_or_logout
    if current_user
      content_tag :li, link_to(t("blacklight.header_links.logout"), destroy_user_session_path)
    else
      content_tag :li, link_to(t("blacklight.header_links.login"), new_user_session_path)
    end
  end

  def edit_user_registration_text
    current_user.to_s.blank? ? t("user_registration") : current_user.to_s
  end

  def render_refworks_link
    if @document.export_formats.keys.include?(:refworks_marc_txt)
      content_tag :li, link_to(t("blacklight.tools.refworks"), refworks_export_url(:id => @document))
    end
  end

  def render_endnote_link
    if @document.export_formats.keys.include?(:endnote)
      content_tag :li, link_to(t("blacklight.tools.endnote"), catalog_path(@document, :format => "endnote"))
    end
  end

  def render_citation_link 
    if (@document.respond_to?(:export_as_mla_citation_txt) || @document.respond_to?(:export_as_apa_citation_txt))
      content_tag :li, link_to(t("blacklight.tools.cite"), citation_catalog_path(:id => @document), {:id => "citeLink", :name => "citation", :class => "lightboxLink"})
    end
  end

  def render_sms_link
    if @document.respond_to?(:to_sms_text)
      content_tag :li, link_to(t("blacklight.tools.sms"), sms_catalog_path(:id => @document), {:id => "smsLink", :name => "sms", :class => "lightboxLink"})
    end
  end

  def render_marc_view_link
    if @document.respond_to?(:to_marc)
      content_tag :li, link_to(t("blacklight.tools.librarian_view"), librarian_view_catalog_path(@document), {:id => "librarianLink", :name => "librarian_view", :class => "lightboxLink"})
    end
  end

  def render_nearby_link
    if @document.respond_to?(:to_marc)
      content_tag :li, link_to(t("check_nearby"), "http://www.worldcat.org/oclc/#{@document[:id]}")
    end
  end

  def render_ead_view_link
    content_tag :li, link_to(t("archivist_view"), catalog_path(params[:id], :format => :xml), {:target => "_blank" })
  end

  def render_fa_view_link
    if request_full_finding_aid?
      content_tag :li, link_to(t("finding_aid"), catalog_path(params[:id]))
    else
      content_tag :li, link_to(t("full_finding_aid"), catalog_path(params[:id], {:full => true}))
    end
  end

  def render_previous_document_link
    if @previous_document
      content_tag :li, link_to_previous_document(@previous_document)
    end
  end

  def render_next_document_link
    if @next_document
      content_tag :li, link_to_next_document(@next_document)
    end
  end

  def render_item_entry_info
    if @previous_document || @next_document
      content_tag :li, item_page_entry_info, :class => "navbar-text"
    end
  end

  def render_more_options_link
    content_tag :li do
      link_to t("more_options"), params.merge(:controller=>"advanced", :action=>"index") , :class=>"advanced_search"
    end
  end

end
