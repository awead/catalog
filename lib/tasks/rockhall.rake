require "solr_ead"
require "rockhall"

namespace :rockhall do
namespace :ead do

  desc "Index ead into solr and create both html and json"
  task :index do
    raise "Please specify your ead, ex. EAD=<path/to/ead" unless ENV['EAD']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        print "Indexing #{File.basename(file)}."
        indexer.update(file)
        print "."
        Rockhall::Indexing.ead_to_html(file)
        print "."
        Rockhall::Indexing.toc_to_json(File.new(file))
        print "done.\n"
      end
    else
      indexer.update(ENV['EAD'])
      Rockhall::Indexing.ead_to_html(ENV['EAD'])
      Rockhall::Indexing.toc_to_json(File.new(ENV['EAD']))
    end

  end

  desc "Convert ead to html only"
  task :to_html do
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
  task :to_json do
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
end