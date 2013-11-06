require "fileutils"
require "solr_ead"
require "rockhall"

namespace :rockhall do
namespace :ead do

  desc "Index ead into solr and create both html and json"
  task :index => :environment do
    ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        print "Indexing #{File.basename(file)}: "
        begin
          indexer.update(file)
          Rockhall::Indexing.ead_to_html(file)
          Rockhall::Indexing.toc_to_json(File.new(file))
          FileUtils.cp(file, Rails.configuration.rockhall_config[:ead_path])
          print "done.\n"
        rescue
          print "failed!\n"
        end
      end
    else
      indexer.update(ENV['EAD'])
      Rockhall::Indexing.ead_to_html(ENV['EAD'])
      Rockhall::Indexing.toc_to_json(File.new(ENV['EAD']))
      FileUtils.cp(ENV['EAD'], Rails.configuration.rockhall_config[:ead_path])
    end
  end

  desc "Convert ead to html only"
  task :to_html => :environment do
    raise "Please specify a path to your ead, ex. EAD=<path/to/ead.xml" unless ENV['EAD']
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        puts "Converting #{File.basename(file)} to html"
        Rockhall::Indexing.ead_to_html(file) if File.extname(file).match("xml$")
      end
    else
      Rockhall::Indexing.ead_to_html(ENV['EAD'])
    end
  end

  desc "Convert ead to json only"
  task :to_json => :environment do
    raise "Please specify your ead, ex. EAD=<path/to/ead.xml" unless ENV['EAD']
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        puts "Converting #{File.basename(file)} to json"
        Rockhall::Indexing.toc_to_json(File.new(file))
      end
    else
      Rockhall::Indexing.toc_to_json(File.new(ENV['EAD']))
    end
  end


end

namespace :marc do

  require "marc"

  desc "Write out marc records from current solr index"
  task :write_out => :environment do
    job = MarcFile.new
    job.write_out
  end

  desc "Index marc record fixtures, or provide a file via MARC_FILE"
  task :index => :environment do
    ENV['CONFIG_PATH'] = locate_path("vendor", "SolrMarc", "config-#{::Rails.env}.properties")
    ENV['SOLRMARC_JAR_PATH'] = locate_path("vendor", "SolrMarc", "SolrMarc.jar")
    ENV['MARC_FILE'] ||= "spec/fixtures/marc/rrhof.mrc"
    Rake::Task["solr:marc:index"].invoke
  end

  desc "Return the info on our marc index environment"
  task :info => :environment do
    ENV['CONFIG_PATH'] = locate_path("vendor", "SolrMarc", "config-#{::Rails.env}.properties")
    ENV['SOLRMARC_JAR_PATH'] = locate_path("vendor", "SolrMarc", "SolrMarc.jar")
    Rake::Task["solr:marc:index:info"].invoke
  end

end

namespace :pbcore do

  desc "Index pbcore solr discovery documents from Hydra"
  task :index => :environment do
    ENV['PBCORE'] = "spec/fixtures/pbcore" unless ENV['PBCORE']
    solr = RSolr.connect :url => Blacklight.solr_config[:url]
    if File.directory?(ENV['PBCORE'])
      Dir.glob(File.join(ENV['PBCORE'],"*")).each do |file|
        print "Indexing #{File.basename(file)}: "
        begin
          solr.add JSON.parse(File.read(file))
          print "done.\n"
        rescue
          print "failed!\n"
        end
      end
    else
      solr.add JSON.parse(File.read(ENV['PBCORE']))
    end
    solr.commit
    solr.optimize
  end

end

namespace :solr do

  desc "Deletes everytyhing from the solr index"
  task :clean => :environment do
    Blacklight.solr.delete_by_query("*:*")
    Blacklight.solr.commit
  end

end

namespace :dev do

  desc "Prepare environment for testing"
  task :prep => ["rockhall:marc:index", "rockhall:ead:index", "rockhall:pbcore:index"]

  desc "Run continuous integration tests"
  task :ci => ["rockhall:jetty:prep", "rockhall:dev:prep", "spec"]

end
end