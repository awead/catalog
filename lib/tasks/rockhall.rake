require "solr_ead"
require "rockhall"

namespace :rockhall do
namespace :ead do

  desc "Index ead into solr and create both html and json"
  task :index => :environment do
    raise "Please specify your ead, ex. EAD=<path/to/ead" unless ENV['EAD']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        print "Indexing #{File.basename(file)}: "
        begin
          indexer.update(file)
          Rockhall::Indexing.ead_to_html(file)
          Rockhall::Indexing.toc_to_json(File.new(file))
          print "done.\n"
        rescue
          print "failed!\n"
        end
      end
    else
      indexer.update(ENV['EAD'])
      Rockhall::Indexing.ead_to_html(ENV['EAD'])
      Rockhall::Indexing.toc_to_json(File.new(ENV['EAD']))
    end
    if Rails.env.match?("production")
      print "Syncing files to remove server: "
      Rake::Task["rockhall:ead:index"].reenable
      Rake::Task["rockhall:ead:index"].invoke
      print "done.\n"
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

  desc "Uses a rsync command to copy ead files to a remote server"
  task :remote => :environment do
    raise "Please specify your ead, ex. EAD=<path/to/ead.xml" unless ENV['EAD']
    unless Rails.configuration.rockhall_config[:ead_remote_path].empty?
      File.directory?(ENV['EAD']) ? Dir.glob(File.join(ENV['EAD'],"*.xml")).collect { |file| Rockhall::Indexing.file_sync(file) } : Rockhall::Indexing.file_sync(ENV['EAD'])
      Dir.glob("public/fa/*.*").collect { |file| Rockhall::Indexing.file_sync(file) }
    end
  end


end
end