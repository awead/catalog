require "nokogiri"

# These are class methods used when indexing ead xml into solr.
class Rockhall::Ead::Converter

  attr_accessor :xsl, :full_xsl, :file, :id

  def initialize file
    raise "Invalid ead id for file" unless valid_ead?(file)
    self.xsl      = Nokogiri::XSLT(File.read(File.join(Rails.root, "xsl", "ead_to_html.xsl")))
    self.full_xsl = Nokogiri::XSLT(File.read(File.join(Rails.root, "xsl", "ead_to_html_full.xsl")))
    self.file     = file
    self.id       = ead_from_file(file)
  end

  def convert
    ead_to_html
    toc_to_json
  end

  # Converts an ead xml file into two html files.  One is for the the default display in
  # Blacklight, which is just the archdesc section of the ead.  The second html file is
  # for the optional display of the entire finding aid.
  def ead_to_html
    default_html
    full_html
  end

  def default_html
    html = Nokogiri(File.read(file))
    dst = File.join(Rails.root, "public", "fa", (id+".html"))
    File.open(dst, "w") { |f| f << cleanup_xml(xsl.apply_to(html).to_s) }
  end

  def full_html
    html = Nokogiri(File.read(file))
    dst = File.join(Rails.root, "public", "fa", (id+"_full.html"))
    File.open(dst, "w") { |f| f << cleanup_xml(full_xsl.apply_to(html).to_s) }
  end

  # AT's process of exporting ead xml sometimes creates some bad characters.  We need
  # to convert them here.
  def cleanup_xml results
    results.gsub!(/<title/,"<span")
    results.gsub!(/<\/title/,"</span")
    results.gsub!(/&lt;title/,"<span")
    results.gsub!(/&lt;\/title/,"</span")
    results.gsub!(/&gt;/,">")
    results.gsub!(/render=/,"class=")
    if ENV['RAILS_RELATIVE_URL_ROOT']
      results.gsub!(/RAILS_RELATIVE_URL_ROOT/,ENV['RAILS_RELATIVE_URL_ROOT'])
    else
      results.gsub!(/RAILS_RELATIVE_URL_ROOT/,"")
    end
    return results
  end

  # Writes a json file for the table of contents using what's in solr.  Used by JSTree
  # to navigate the collection inventory.
  #
  # Uses the CollectionTree to reassemble each component into its correct hierarchy.
  def toc_to_json
    inventory = Rockhall::Ead::Inventory.new(id)
    toc_dst = File.join(Rails.root, "public", "fa", (id + "_toc.json"))
    File.open(toc_dst, "w") { |f| f << inventory.tree.to_json }
  end

  private

  def valid_ead? file
    if ead_from_file(file).match(/[A-Z]{2,3}-[0-9]{4,4}/)
      return true
    else
      return false
    end
  end

  def ead_from_file file
    f = File.new(file)
    Rockhall::Ead::Document.from_xml(Nokogiri::XML(f)).eadid.first
  end

end
