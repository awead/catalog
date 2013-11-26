module BookmarksHelper

  def render_bookmarks_index_view
    if current_or_guest_user.blank?
      content_tag :p, t('blacklight.bookmarks.need_login')
    elsif @document_list.blank?
      content_tag :p, t('blacklight.bookmarks.no_bookmarks')
    else
      render "bookmarks/list_view"
    end
  end

end
