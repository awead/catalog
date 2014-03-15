require "fileutils"
require "solr_ead"
require "rockhall"
require "colorize"

namespace :rockhall do
namespace :ead do

  desc "Index ead into solr and create both html and json"
  task :index => :environment do
    ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
    indexer = Rockhall::Ead::Indexer.new(:document=>Rockhall::Ead::Document, :component=>Rockhall::Ead::Component)
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        print "Indexing #{File.basename(file)}: "
        begin
          indexer.update file
          Rockhall::Ead::Converter.new(file).convert
          FileUtils.cp(file, Rails.configuration.rockhall_config[:ead_path])
          puts "done.".colorize(:green)
        rescue
          puts "failed.".colorize(:red)  
        end
      end
    else
      indexer.update ENV['EAD']
      Rockhall::Ead::Converter.new(ENV['EAD']).convert
      FileUtils.cp(ENV['EAD'], Rails.configuration.rockhall_config[:ead_path])
    end
  end

  desc "Convert ead to html and json"
  task :convert => :environment do
    ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        puts "Converting #{File.basename(file)}"
        Rockhall::Ead::Converter.new(file).convert if File.extname(file).match("xml$")
      end
    else
      Rockhall::Ead::Converter.new(ENV['EAD']).convert
    end
  end

  desc "Update with data from AT"
  task :atk_update => :environment do 
    ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        puts "Updating #{File.basename(file)} with additional data from AT"
        Rockhall::Ead::Indexing.atk_update(file) if File.extname(file).match("xml$")
      end
    else
      Rockhall::Ead::Indexing.atk_update(ENV['EAD'])
    end
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
