require "nokogiri"

# These are class methods used when indexing ead xml into solr.
module Rockhall::Indexing

  # Converts an ead xml file into two html files.  One is for the the default display in
  # Blacklight, which is just the archdesc section of the ead.  The second html file is
  # for the optional display of the entire finding aid.
  def self.ead_to_html(file)
    self.default_html(file)
    self.full_html(file)
  end

  def self.default_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    id = get_eadid_from_file(file)
    dst = File.join(Rails.root, "public", "fa", (id+".html"))
    File.open(dst, "w") { |f| f << cleanup_xml(xsl.apply_to(html).to_s) }
  end

  def self.full_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html_full.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    id = get_eadid_from_file(file)
    dst = File.join(Rails.root, "public", "fa", (id+"_full.html"))
    File.open(dst, "w") { |f| f << cleanup_xml(xsl.apply_to(html).to_s) }
  end

  # AT's process of exporting ead xml sometimes creates some bad characters.  We need
  # to convert them here.
  def self.cleanup_xml(results)
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
  def self.toc_to_json(file)
    id = get_eadid_from_file(file)
    inventory = Rockhall::CollectionInventory.new(id)
    #if inventory.depth > 1
      toc_dst = File.join(Rails.root, "public", "fa", (id + "_toc.json"))
      File.open(toc_dst, "w") { |f| f << inventory.tree.to_json }
    #end
  end

  # Queries an xml file and returns the value for eadid
  def self.get_eadid_from_file(file)
    file = File.new(file) if file.is_a?(String)
    id = Rockhall::EadDocument.from_xml(Nokogiri::XML(file)).eadid.first
    raise "Found no eadid in #{File.basename(file)}" if id.nil?
    if valid_ead?(id)
      return id
    else
      raise "ID is not in the correct format: #{id}"
    end
  end

  # Returns true if the given id is formatted correctly
  def self.valid_ead?(id)
    id.match(/[A-Z]{2,3}-[0-9]{4,4}/) ? true : false
  end

  # Copies files over to a remote server via rsync
  # When files are indexed on a staging server, the html and json files are copied to a local directory, usually:
  #   public/fa
  # If you're using a different production server, those files need to be sent over it, in the same location.
  # Uses rsync system command with options specified in rockhall_config.rb
  def self.file_sync(src)
    command = ["rsync", "-ru", src]
    command << Rails.configuration.rockhall_config[:ead_remote_user]+"@"+Rails.configuration.rockhall_config[:ead_remote_host]+":"+Rails.configuration.rockhall_config[:ead_remote_path]
    system command.join(" ")
  end


end