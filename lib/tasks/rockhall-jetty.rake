namespace :rockhall do
namespace :jetty do

  desc "Prepare jetty"
  task :prep => ["jetty:stop", "rockhall:jetty:clean", "rockhall:jetty:config", "jetty:start"]

  desc "Unpack a clean version of solr-jetty"
  task :clean do
    Jettywrapper.url = "https://github.com/awead/solr-jetty/archive/v1.zip"
    Jettywrapper.clean
  end

  desc "Configure solr-jetty instance"
  task :config do
    `cp solr/schema.xml jetty/solr/blacklight-dev-core/conf/schema.xml`
    `cp solr/schema.xml jetty/solr/blacklight-test-core/conf/schema.xml`
    `cp solr/solrconfig.xml jetty/solr/blacklight-dev-core/conf/solrconfig.xml`
    `cp solr/solrconfig.xml jetty/solr/blacklight-test-core/conf/solrconfig.xml`
  end

  desc "Reset the solr schema to what's currently in jetty"
  task :reset_schema do
    `cp jetty/solr/blacklight-dev-core/conf/schema.xml solr/schema.xml`
  end

  desc "Reset solr config to what's currently in jetty"
  task :reset_solrconfig do
    `cp jetty/solr/blacklight-dev-core/conf/solrconfig.xml solr/solrconfig.xml`
  end

end
end