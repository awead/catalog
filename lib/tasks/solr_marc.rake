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

vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?

begin
  require 'cucumber/rake/task'

  namespace :cucumber do

    Cucumber::Rake::Task.new({:marc => 'db:test:prepare'}, 'Run marc features') do |t|
      t.binary = vendored_cucumber_bin
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'marc'
    end

  end
end
