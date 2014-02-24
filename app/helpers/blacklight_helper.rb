# Override methods in Blacklight::BlacklightHelperBehavior
module BlacklightHelper

  include Blacklight::BlacklightHelperBehavior


  def field_value_separator
    '<br />'
  end

  # Render the document index heading
  # Override to highlight seach results in the heading
  def render_document_index_label doc, opts = {}
    label = nil
    label ||= doc.highlight_field(opts[:label]) if opts[:label].instance_of?(Symbol) && doc.has_highlight_field?(opts[:label])
    label ||= doc.get(opts[:label], :sep => nil) if opts[:label].instance_of? Symbol
    label ||= opts[:label].call(doc, opts) if opts[:label].instance_of? Proc
    label ||= opts[:label] if opts[:label].is_a? String
    label ||= doc.id
    render_field_value label
  end

end
