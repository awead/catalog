require "solr_ead"
require "rockhall"

namespace :rockhall do
namespace :ead do

  desc "Index an ead using RockhallDocument"
  task :index do
    raise "Please specify your ead, ex. FILE=<path/to/ead.xml" unless ENV['FILE']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    indexer.update(ENV['FILE'])
    Rockhall::Indexing.ead_to_html(ENV['FILE'])
    id = File.basename(ENV['FILE']).gsub(/\.xml$/,"")
    Rockhall::Indexing.toc_to_json(id)
  end

  desc "Convert ead to html (without indexing in Solr)"
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

  desc "Create json file for the table of contents"
  task :to_json do
    raise "Please specify your ead, ex. EAD=<path/to/ead.xml" unless ENV['EAD']
    if File.directory?(ENV['EAD'])
      Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
        id = File.basename(file).gsub(/\.xml$/,"")
        puts "Processing json for #{id}"
        Rockhall::Indexing.toc_to_json(id)
      end
    else
      id = File.basename(ENV['EAD']).gsub(/\.xml$/,"")
      Rockhall::Indexing.toc_to_json(id)
    end
  end

  desc "Index a directory of ead files using RockhallDocument"
  task :index_dir do
    raise "Please specify your direction, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new(:document=>Rockhall::EadDocument, :component=>Rockhall::EadComponent)
    Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
      print "Indexing #{File.basename(file)}..."
      if File.extname(file).match("xml$")
        indexer.update(file)
        Rockhall::Indexing.ead_to_html(file)
        id = File.basename(file).gsub(/\.xml$/,"")
        Rockhall::Indexing.toc_to_json(id)
      end
      print "done.\n"
    end
  end

end
end