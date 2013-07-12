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

end

namespace :pbcore do

  desc "Index pbcore solr discovery documents from Hydra"
  task :index => :environment do
    raise "Please specify the path to the pbcore solr document with PBCORE=path/to/doc.json" unless ENV['PBCORE']
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
end