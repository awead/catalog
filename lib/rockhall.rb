require 'marc'

module Rockhall
  extend ActiveSupport::Autoload

  autoload :Catalog
  autoload :Solr
  autoload :SolrHelper
  autoload :Ead

end
