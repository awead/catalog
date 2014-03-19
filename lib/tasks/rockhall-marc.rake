require "marc"

namespace :rockhall do
namespace :marc do

  desc "Write out marc records from current solr index"
  task :write_out => :environment do
    job = MarcFile.new
    job.write_out
  end

  desc "Index marc record fixtures (default), or by file or directory, specified by MARC_FILE="
  task :index => :environment do
    ENV['CONFIG_PATH'] = locate_path("vendor", "SolrMarc", "config-#{::Rails.env}.properties")
    ENV['SOLRMARC_JAR_PATH'] = locate_path("vendor", "SolrMarc", "SolrMarc.jar")
    ENV['MARC_FILE'] ||= "spec/fixtures/marc/rrhof.mrc"
    ENV['MARC_FILE'] ||= "spec/fixtures/marc/rrhof.mrc"
    
    if File.directory?(ENV['MARC_FILE'])
      Dir.glob(File.join(ENV['MARC_FILE'],"*.mrc")).each do |file|
        print "Indexing #{File.basename(file)}: "
        ENV['MARC_FILE'] = file
        `bundle exec rake solr:marc:index`
      end
    else
      Rake::Task["solr:marc:index"].invoke
    end

  end

  desc "Return the info on our marc index environment"
  task :info => :environment do
    ENV['CONFIG_PATH'] = locate_path("vendor", "SolrMarc", "config-#{::Rails.env}.properties")
    ENV['SOLRMARC_JAR_PATH'] = locate_path("vendor", "SolrMarc", "SolrMarc.jar")
    Rake::Task["solr:marc:index:info"].invoke
  end

  desc "delete a single marc record, given by ID=<id number>"
  task :delete => :environment do
    id = ENV['ID']
    raise "Please give the id of the record to delete, like ID=123456789" unless id
    print "Deleting #{id}, "
    Blacklight.solr.delete_by_id(id)
    puts "commiting results"
    Blacklight.solr.commit
  end

  desc "delete all marc records"
  task :delete_all => :environment do
    current_marc_formats.each do |format|
      Blacklight.solr.get("select", :params => format_query(format))["response"]["docs"].each do |doc|
        doc_id = doc["id"]
        puts "Deleting #{format}: #{doc_id}"
        Blacklight.solr.delete_by_id(doc_id)
      end
    end
    puts "Commiting results"
    Blacklight.solr.commit
  end

  desc "reindex all marc records"
  task :reindex => ["delete_all", "index", "rockhall:pbcore:index"]

end
end

def format_query format
  {
    :q => Solrizer.solr_name("format", :facetable) + ":" + format,
    :qt => "document",
    :rows => 1000000,
    :fl => "id"
  }
end


def formats_query
  {
    :"facet.field" => Solrizer.solr_name("format", :facetable),
    :fl => Solrizer.solr_name("format", :searchable),
    :qt => "search"
  }
end

def current_marc_formats
 r = Blacklight.solr.get "select", :params => formats_query
 all = r["facet_counts"]["facet_fields"][Solrizer.solr_name("format", :facetable)].collect { |s| s if s.kind_of?(String) }.compact
 all.delete("Archival Collection")
 all.delete("Archival Item")
 return all
end
