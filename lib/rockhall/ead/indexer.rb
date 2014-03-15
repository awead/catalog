require "artk"

# These are class methods used when indexing ead xml into solr.
class Rockhall::Ead::Indexer < SolrEad::Indexer

  attr_accessor :ref_hash

  # Build another solr document using fields gathered directly from the AT database
  def atk_solr_document ref
    if Rails.env.match("test")
      get_sample_atk_solr_document
    else
      build_atk_solr_document(ref)
    end
  end

  # If were running tests, we won't have access to the AT database, so we build a fake solr document to use for 
  # testing.
  def get_sample_atk_solr_document solr_doc = Hash.new
    solr_doc.merge!( { Solrizer.solr_name("shelf", :displayable) => "Test shelf location" } )
    return solr_doc
  end

  def build_atk_solr_document ref, solr_doc = Hash.new
    unless ref_hash[ref].nil?
      locations = get_locations_from_component(ref_hash[ref])
      solr_doc.merge!( { Solrizer.solr_name("shelf", :displayable) => locations } ) 
      solr_doc.merge!( { Solrizer.solr_name("shelf", :searchable) => locations } ) 
    end
    return solr_doc
  end

  # Build a hash of component ref ids and Artk::Component ids.  This allows us to query a specific component from the
  # AT table using only the ref id, ex. ref1234.  However, this can only be done if we have a complete list of all the
  # ref ids for a given collection.
  def build_ref_hash file, hash = Hash.new
    f = File.new(file)
    ead = Rockhall::Ead::Document.from_xml(Nokogiri::XML(f)).eadid.first
    Artk::Resource.find_by_ead_id(ead).all_series.collect { |c| hash[c.persistentId] = c.id }
    self.ref_hash = hash
  end

  private

  # Override #add_components to inject additional fields from Archivists' Toolkit into the 
  # the solr document for ead components.  Becase these fields are coming diretly from the 
  # AT database, it's not possible to create fixtures for them during automated testing.
  # Therefore, when testing, the field is replaced with a placeholder string.
  def add_components file, counter = 1
    build_ref_hash(file) unless Rails.env.match("test")
    components(file).each do |node|
      solr_doc = om_component_from_node(node).to_solr(additional_component_fields(node))
      solr_doc.merge!({Solrizer.solr_name("sort", :sortable, :type => :integer) => counter.to_s})
      solr_doc.merge!(atk_solr_document(solr_doc[Solrizer.solr_name("ref", :stored_sortable)]))
      solr.add solr_doc
      counter = counter + 1
    end
  end

  def get_locations_from_component id, locations = Array.new
    begin  
      Artk::Component.find(id).instances.collect { |inst| locations << format_location(inst) }
    rescue
      logger.error("Rockhall::Ead::Indexer: Unable to get locations for Artk::Component.id #{id}")
    end
    return locations
  end

  def format_location instance, results = Array.new
    [1,2,3].each do |i|
      results << (instance.location.coordinate_label(i) + ": " + instance.location.coordinate_value(i)) unless instance.location.coordinate_value(i).nil?
    end
    return results.join(" / ")
  end

end
