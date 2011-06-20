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

  end
end
