namespace :solr do
namespace :ead do

  desc 'delete all your eads from solr'
  task :delete_all => :environment do
    [Rails.configuration.rockhall_config[:ead_format_name],"component"].each do |format|
      result = Blacklight.solr.find( :q => "{!raw f=format rows=1000000}#{format}" )
      result["response"]["docs"].each do |doc|
        doc_id = doc["id"]
        puts "Deleting #{format}: #{doc_id}"
        Blacklight.solr.delete_by_id(doc_id)
      end
    end
    (1..5).each do |level|
      result = Blacklight.solr.find( {:q => "component_level:#{level.to_s}", :qt => "standard", :fl => "id", :rows => "100000" } )
      result["response"]["docs"].each do |doc|
        doc_id = doc["id"]
        puts "Deleting #{level.to_s}: #{doc_id}"
        Blacklight.solr.delete_by_id(doc_id)
      end
    end
    puts "Commiting results"
    Blacklight.solr.commit
  end

  desc 'delete a single ead from solr, given by ID=<ead_id>'
  task :delete => :environment do
    doc_id = ENV["ID"]
    raise "Please specify an id with ID=ARC-TEST" unless doc_id
    result = Blacklight.solr.find( :q => "{!raw f=format rows=100}#{doc_id}" )
    result["response"]["docs"].each do |doc|
      doc_id = doc["id"]
      puts "Deleting ead: #{doc_id}"
      Blacklight.solr.delete_by_id(doc_id)
    end
    result = Blacklight.solr.find( :q => "{!raw f=ead_id rows=10000}#{doc_id}" )
    result["response"]["docs"].each do |doc|
      doc_id = doc["id"]
      puts "Deleting folder: #{doc_id}"
      Blacklight.solr.delete_by_id(doc_id)
    end
    puts "Commiting results"
    Blacklight.solr.commit
  end

  desc "index a directory of ead files, given by DIR=/path/to/folder or rockhall_config[:ead_dir]"
  task :index_dir=>:environment do
    if ENV['DIR'].nil?
      d = Rails.configuration.rockhall_config[:ead_dir]
    else
      d = ENV['DIR']
    end
    raise "Please specify a directory, like DIR=/home/you/folder." unless d and File.exists?(d)
    files = Dir.entries(d)
    files.each do |f|
      doc  = File.join(d, f)
      if File.extname(doc) == ".xml"
        puts "[-----------------------------------------]"
        puts "indexing #{doc}"
        ENV['FILE'] = doc
        begin
          Rake::Task["solr:ead:index"].invoke
        rescue StandardError => bang
          puts "OOPPS!!!: #{ bang} "
        end
        Rake::Task["solr:ead:index"].reenable
      end
    end
  end

  desc "index a single ead, given by FILE=/path/to/file"
  task :index=>:environment do
    require 'nokogiri'
    require 'pp'
    include Rockhall::EadMethods

    xml = Rockhall::EadMethods.ead_rake_xml(fetch_env_file)
    id = Rockhall::EadMethods.ead_id(xml)
    collection = xml.xpath("//archdesc/did/unittitle").first.text.gsub("\n",'').gsub(/\s+/, ' ').strip

    puts "Deleting existing ead..."
    ENV['ID'] = id
    begin
      Rake::Task["solr:ead:delete"].invoke
    rescue StandardError => bang
      puts "OOPPS!!!: #{ bang} "
    end
    Rake::Task["solr:ead:delete"].reenable
    puts "done"

    puts "Indexing #{id}"

    # Facets
    # Here's a complete list of all our headings used in the EAD:
    # ["corpname", "genreform", "persname", "subject", "title", "occupation", "geogname", "famname", "function"]

    # topic facets
    subject_fields = ["subject", "title", "occupation", "geogname", "function"]
    subject = subject_fields.map do |field|
      xml.xpath('/ead/archdesc/controlaccess/' + field).map do |field_value|
        field_value.text.strip.sub(/\.$/, '')
      end
    end

    # name facets
    name_fields = ["corpname", "persname", "famname" ]
    name = name_fields.map do |field|
      xml.xpath('/ead/archdesc/controlaccess/' + field).map do |field_value|
        field_value.text.strip.sub(/\.$/, '')
      end
    end

    # Genre facets
    genre_fields = [ "genreform" ]
    genre = genre_fields.map do |field|
      xml.xpath('/ead/archdesc/controlaccess/' + field).map do |field_value|
        field_value.text.strip.sub(/\.$/, '')
      end
    end

    # index components
    level = 5
    while level > 0
      puts "... level #{level}"
      counter = 1
      xml.search("//c0#{level.to_s}").each do |node|
        doc = Rockhall::EadMethods.get_component_doc(node,level,counter)
        response = Blacklight.solr.add doc
        commit = Blacklight.solr.commit
        counter = counter + 1
      end
      level = level - 1
    end

    # remove component levels 2 and higher
    xml.search("//c02").each { |node| node.remove }

    solr_doc = Rockhall::EadMethods.get_ead_doc(xml)
    solr_doc.merge!({:subject_topic_facet => subject.flatten.uniq})
    solr_doc.merge!({:subject_t => subject.flatten.uniq})
    solr_doc.merge!({:name_facet => name.flatten.uniq})
    solr_doc.merge!({:contributors_t => name.flatten.uniq})
    solr_doc.merge!({:genre_facet => genre.flatten.uniq})
    solr_doc.merge!({:genre_t => genre.flatten.uniq})
    puts "... document "
    response = Blacklight.solr.add solr_doc
    commit = Blacklight.solr.commit

    puts "Done"

  end

  desc "re-index existing eads from files in rockhall_config[:ead_dir]"
  task :reindex =>:environment do
    result = Blacklight.solr.find( :q => "{!raw f=format rows=1000000}Archival Collection" )
    result["response"]["docs"].each do |doc|
      ead_id = doc["id"]
      puts "[-------------------------------------------------------------------------------------]"
      puts "[-------------------------------------------------------------------------------------]"
      puts " Re-indexing #{ead_id} from xml file at #{Rails.configuration.rockhall_config[:ead_dir]}"
      path = File.join Rails.configuration.rockhall_config[:ead_dir], (ead_id + ".xml")
      unless File.exists?(path)
        puts " File not found, skipping!"
        puts "[-------------------------------------------------------------------------------------]"
        puts "[-------------------------------------------------------------------------------------]"
        next
      end
      puts " Found the file, proceeding"
      puts "[-------------------------------------------------------------------------------------]"
      puts "[-------------------------------------------------------------------------------------]"
      ENV['FILE'] = path
      Rake::Task["solr:ead:index"].invoke
      Rake::Task["solr:ead:index"].reenable
      puts "[-------------------------------------------------------------------------------------]"
      puts "[-------------------------------------------------------------------------------------]"
      puts " Finished re-indexing #{ead_id}"
      puts "[-------------------------------------------------------------------------------------]"
      puts "[-------------------------------------------------------------------------------------]"
    end
  end

  # Helper methods

  def fetch_env_file
    f = ENV['FILE']
    raise "Invalid file. Set the location of the file by using the FILE argument." unless f and File.exists?(f)
    f
  end

end
end
