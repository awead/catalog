module SearchesHelper

  def render_search_history_table
    if @searches.blank?
      content_tag :p, t("blacklight.search_history.no_history")
    else
      render "shared/searches_table"
    end
  end

  def render_saved_searches_table
    if current_or_guest_user.blank?
      content_tag :p, t("blacklight.saved_searches.need_login")
    elsif @searches.blank?
      content_tag :p, t("blacklight.saved_searches.no_searches")
    else
      render "shared/searches_table"
    end
  end

  def render_clear_search_history_link
    if current_page?(search_history_path) && @searches.count > 0
      content_tag :li do
        link_to t("blacklight.search_history.clear.action_title"), clear_search_history_path, 
          :method => :delete, :data => { :confirm => t("blacklight.search_history.clear.action_confirm") }
      end
    end
  end

  def render_save_or_clear_link search
    if current_or_guest_user && search.saved?
      button_to t("blacklight.search_history.forget"), forget_search_path(search.id), :class => "btn btn-default"
    else
      button_to t("blacklight.search_history.save"), save_search_path(search.id), :method => :put, :class => "btn btn-default"
    end
  end

  def render_clear_saved_searches_link
    if current_page?(saved_searches_path) && @searches.count > 0
      content_tag :li do
        link_to t("blacklight.saved_searches.clear.action_title"), 
          clear_saved_searches_path, :method => :delete, 
          :data => { :confirm => t("blacklight.saved_searches.clear.action_confirm") }
      end
    end
  end

end
