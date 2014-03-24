module UsersHelper

  def render_cancel_account_link
    if current_page?(edit_user_registration_path)
      content_tag :li do
        link_to "Cancel my account", registration_path(resource_name), :data => { :confirm => "Are you sure?" }, :method => :delete
      end
    end
  end

  def render_waiting_on_confirmation
    if devise_mapping.confirmable? && resource.pending_reconfirmation?
      content_tag :div, t("devise.edit.waiting"), :class => "alert alert-warning"
    end
  end

  def render_error_messages
    unless resource.errors.empty?
      render :partial => "devise/shared/user_error_message", :locals => { :sentence => error_sentence, :messages => error_messages }
    end
  end

  def render_devise_links
    render "devise/shared/links"
  end

  private

  def error_messages
    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
  end

  def error_sentence
    I18n.t("errors.messages.not_saved", :count => resource.errors.count, :resource => resource.class.model_name.human.downcase)
  end

end
