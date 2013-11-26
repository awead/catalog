module SearchHistoryConstraintsHelper
  include Blacklight::SearchHistoryConstraintsHelperBehavior

  def render_search_to_s_element(key, value, options = {})
    content_tag(:span, render_filter_name(key) + content_tag(:span, value, :class => 'filterValues'), :class => 'label constraint')
  end

end
