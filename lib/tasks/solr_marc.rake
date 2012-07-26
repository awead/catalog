namespace :solr do
  namespace :marc do

    desc "Index directory of marc files"
    task :index_dir do

      d = ENV['DIR']
      raise "Please specify a directory, like DIR=/home/you/folder." unless d and File.exists?(d)
      files = Dir.entries(d)
      files.each do |f|
        doc  = File.join(d, f)
        if File.extname(doc) == ".mrc"
          puts "Indexing #{doc}"
          ENV['MARC_FILE'] = doc
          `rake solr:marc:index`
          #Rake::Task["solr:marc:index"].invoke
          #Rake::Task["solr:marc:index"].reenable
        end
      end

    end

    desc "delete a single marc record, given by ID=<id number>"
    task :delete => :environment do
      id = ENV['ID']
      raise "Please give the id of the record to delete, like ID=123456789" unless id
      result = Blacklight.solr.find( {:q => "id:#{id}", :qt => "document", :fl => "id", :rows => "1" } )
      result["response"]["docs"].each do |doc|
        doc_id = doc["id"]
        puts "Deleting #{doc_id}"
        Blacklight.solr.delete_by_id(doc_id)
      end
      puts "Commiting results"
      Blacklight.solr.commit
    end

    desc "delete all marc records"
    task :delete_all => :environment do
      ["Book","Score","Website","Periodical","Video","Audio","unknown","Image","Map","Theses/Dissertations"].each do |format|
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
