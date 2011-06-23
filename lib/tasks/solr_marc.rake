require "ftools"

namespace :solr do
  namespace :marc do

    desc "Index directory of marc files"
    task :index_dir do

      d = ENV['DIR']
      raise "Please specify a directory, like DIR=/home/you/folder." unless d and File.exists?(d)
      files = Dir.entries(d)
      files.each do |f|
        doc  = File.catname(f, d)
        if File.extname(doc) == ".mrc"
          puts "Indexing #{doc}"
          ENV['MARC_FILE'] = doc
          `rake solr:marc:index`
          #Rake::Task["solr:marc:index"].invoke
          #Rake::Task["solr:marc:index"].reenable
        end
      end

    end

    desc 'delete all marc records'
    task :delete => :environment do
      ["Book","Score","Website","Periodical"].each do |format|
        result = Blacklight.solr.find( :q => "{!raw f=format rows=1000000}#{format}" )
        result["response"]["docs"].each do |doc|
          doc_id = doc["id"]
          puts "Deleting #{format}: #{doc_id}"
          Blacklight.solr.delete_by_id(doc_id)
        end
      end
      puts "Commiting results"
      Blacklight.solr.commit
    end

  end
end
