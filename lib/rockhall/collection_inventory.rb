# Rockhall::CollectionTree returns a nested array that represents series and subseries
# components.  The array conforms to the JSTree format.

module Rockhall
class CollectionInventory

  attr_accessor :id, :tree, :depth

  def initialize(id)
    @id   = id
    @tree =  Array.new
    solr_query.each do |series|
      @tree << json_node(series)
      @depth = 1
    end
    add_addl_series  
  end

  def add_addl_series
    add_second_level
    add_third_level
    add_fourth_level
  end

  def add_second_level
    self.tree.each do |parent|
      node = Array.new
      solr_query({:parent => parent["metadata"]["ref"]}).each do |series|
        node << json_node(series)
      end
      parent["children"] = node
      @depth = 2 unless node.empty?
    end
  end

  def add_third_level
    self.tree.each do |level1|
      level1["children"].each do |parent|
        node = Array.new
        solr_query({:parent => parent["metadata"]["ref"]}).each do |series|
          node << json_node(series)
        end
        parent["children"] = node
        @depth = 3 unless node.empty?
      end
    end
  end

  def add_fourth_level
    self.tree.each do |level1|
      level1["children"].each do |level2|
        level2["children"].each do |parent|
          node = Array.new
          solr_query({:parent => parent["metadata"]["ref"]}).each do |series|
            node << json_node(series)
          end
          parent["children"] = node
          @depth = 4 unless node.empty?
        end
      end
    end
  end

  def solr_query(opts={}, query = Hash.new)
    if opts[:parent]
      query[:q] = 'ead_id:"' + @id + '" AND component_children_b:TRUE AND parent_id:"' + opts[:parent] + '"'
    else
      query[:q] = 'ead_id:"' + @id + '" AND component_level_i:1'
    end
    query[:fl]   = 'id, component_level_i, parent_id, title_display, ref_id, ead_id'
    query[:qt]   = 'document'
    query[:rows] = 10000
    Blacklight.solr.find(query)["response"]["docs"].collect { |doc| doc }
  end

  def json_node series, node = Hash.new, metadata = Hash.new, attr = Hash.new
    node["data"] = series["title_display"]
    metadata["id"] = series["id"]
    metadata["ref"] = series["ref_id"]
    metadata["eadid"] = series["ead_id"]
    attr["id"] = series["id"]
    node["metadata"] = metadata
    node["attr"] = attr
    return node
  end


end
end