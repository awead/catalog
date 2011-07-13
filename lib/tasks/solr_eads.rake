namespace :eads do
  desc 'delete all from solr'
  task :delete_solr => :environment do
    [Blacklight.config[:ead_format_name],"component"].each do |format|
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

  desc 'delete an ead from solr'
  task :delete_ead => :environment do
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


  desc "fetch all updated ead xml for each ead"
  task :fetch_all => :environment do
    eads = Ead.all
    eads.each do |ead|
      ENV['EADID'] = ead.eadid
      Rake::Task["eads:fetch"].invoke
      Rake::Task["eads:fetch"].reenable
    end
    Blacklight.solr.commit
  end

  desc "fetch updated ead xml for each ead"
  task :fetch => :environment do
    (puts 'no EADID'; exit) if !ENV['EADID']
    ENV['NOSOLRCOMMIT'] = 'true'
    ead = Ead.find(ENV['EADID'])
    puts; puts ead.eadid
    if ead.save!
      puts "saved: " + ead.eadid
    else
      puts "NOT SAVED: " + ead.eadid
    end
  end


end

namespace :solr do
  def fetch_env_file
    f = ENV['FILE']
    raise "Invalid file. Set the location of the file by using the FILE argument." unless f and File.exists?(f)
    f
  end


  namespace :index do
    desc "index a directory of ead files"
    task :ead_dir=>:environment do
      if ENV['DIR'].nil?
        d = Blacklight.config[:ead_dir]
      else
        d = ENV['DIR']
      end
      raise "Please specify a directory, like DIR=/home/you/folder." unless d and File.exists?(d)
      files = Dir.entries(d)
      files.each do |f|
        doc  = File.catname(f, d)
        if File.extname(doc) == ".xml"
          puts "[-----------------------------------------]"
          puts "indexing #{doc}"
          ENV['FILE'] = doc
          begin
            Rake::Task["solr:index:ead"].invoke
          rescue StandardError => bang
            puts "OOPPS!!!: #{ bang} "
          end
          Rake::Task["solr:index:ead"].reenable
        end
      end
    end

    desc "index ead sample data from NCSU"
    task :ead_sample_data => :environment do
      ENV['FILE'] = "#{RAILS_ROOT}/vendor/plugins/blacklight_ext_ead_simple/data/*"
      Rake::Task["solr:index:ead_dir"].invoke
    end

    desc "Index an EAD file at FILE=<location-of-file>."
    task :ead=>:environment do
      require 'nokogiri'
      require 'pp'
      include Rockhall::EadMethods

      xml = Rockhall::EadMethods.ead_rake_xml(fetch_env_file)
      id = Rockhall::EadMethods.ead_id(xml)
      collection = xml.xpath("//archdesc/did/unittitle").first.text.gsub("\n",'').gsub(/\s+/, ' ').strip

      puts "Indexing #{id}"

      # gather subject fields splitting on --
      subject_fields = ['corpname','famname','occupation','persname', 'subject', 'genreform']
      subject = subject_fields.map do |field|
        xml.xpath('/ead/archdesc/controlaccess/' + field).map do |field_value|
          field_value.text.split('--').map do |value|
            value.strip.sub(/\.$/, '')
          end
        end
      end

      # index components
      level = 5
      while level > 0
        puts "... level #{level}"
        xml.search("//c0#{level.to_s}").each do |node|
          doc = Rockhall::EadMethods.get_component_doc(node,level)
          if !doc[:title_display].blank?
            response = Blacklight.solr.add doc
            commit = Blacklight.solr.commit
          end
        end
        level = level - 1
      end

      # remove component levels 2 and higher
      xml.search("//c02").each { |node| node.remove }

      solr_doc = Rockhall::EadMethods.get_ead_doc(xml)
      solr_doc.merge!({:subject_topic_facet => subject.flatten.uniq})
      if !solr_doc[:title_display].blank?
        puts "... document "
        response = Blacklight.solr.add solr_doc
        commit = Blacklight.solr.commit
      end

      puts "Done"

    end
  end
end

vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?

begin
  require 'cucumber/rake/task'

  namespace :cucumber do

    Cucumber::Rake::Task.new({:ead => 'db:test:prepare'}, 'Run ead features') do |t|
      t.binary = vendored_cucumber_bin
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'ead'
    end

  end
end

