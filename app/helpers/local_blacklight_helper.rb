module LocalBlacklightHelper

  #
  # These methods override helper methods in the Blacklight gem
  #

  def application_name
    'Rock and Roll Hall of Fame and Museum | Library and Archives | Catalog'
  end

  # overrides app/helpers/blacklight/blacklight_helper_behavior.rb
  def render_document_heading
    render :partial => "catalog/rockhall_heading"
  end

end