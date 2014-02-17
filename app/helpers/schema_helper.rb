module SchemaHelper

  def collection_or_item_page
    if @component.nil?
      "http://schema.org/CollectionPage" 
    else
      @component.get(Solrizer.solr_name("component_children", :type=>:boolean)) ? "http://schema.org/CollectionPage" : "http://schema.org/ItemPage"
    end
  end

  def render_property_url
    content_tag :meta, nil, :itemprop => "url", :content => request.original_url
  end

  def render_schema_property values, property
    values.collect {|v| tag_value_with_property(v,property,{:class => "itemprop"})}.join.html_safe
  end

  def tag_value_with_property v, p, opts={}
    content_tag :span, v.html_safe, :itemprop => p, :class => opts[:class]
  end

  def tag_value_is_part_of v, opts={}
    content_tag :span, v.html_safe, :itemprop => "isPartOf", :itemscope => true, :itemtype => "http://schema.org/CollectionPage"
  end

end
