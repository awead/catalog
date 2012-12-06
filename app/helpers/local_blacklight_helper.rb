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

  # This replaces Blacklight::BlacklightHelperBehavior.link_to_document to
  # render a link to an archival item.  The behavior for all other formats
  # is the same
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    label ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts

    if doc["format"] == "Archival Item"
      id, refnum = doc["id"].split("ref")
      link_to label, catalog_path([id,"ref"+refnum]), { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
    else
      link_to label, doc, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
    end
  end

end