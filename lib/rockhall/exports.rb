# A Blacklight::Solr::Document::Extension that allows us to export the solr document in different formats

module Rockhall::Exports
  def self.extended(document)
    Rockhall::Exports.register_export_formats( document )
  end

  def self.register_export_formats(document)
    document.will_export_as(:xml,   "text/xml")
  end

  def export_as_ead
    file = File.join(Rails.root, Rails.configuration.rockhall_config[:ead_path], (self.id.gsub!(/-/,".") + "-ead.xml"))
    File.exists?(file) ? File.new(file).read : export_as_dc_xml
  end

  # This will override Blacklight's default of exporting .xml as opensearch xml 
  alias_method :export_as_xml, :export_as_ead

end
