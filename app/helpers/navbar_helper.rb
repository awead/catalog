module NavbarHelper

  def render_login_or_logout
    if current_user
      content_tag :li, link_to(t('blacklight.header_links.logout'), destroy_user_session_path)
    else
      content_tag :li, link_to(t('blacklight.header_links.login'), new_user_session_path)
    end
  end

  def edit_user_registration_text
    current_user.to_s.blank? ? t('user_registration') : current_user.to_s
  end

  def account_dropdown_text
    [t('account'), content_tag(:b, nil, :class => "caret")].join(" ").html_safe
  end

  def search_button_text
    [t('blacklight.search.form.submit'), content_tag(:i, nil, :class => "icon-search icon-white")].join(" ").html_safe
  end

end