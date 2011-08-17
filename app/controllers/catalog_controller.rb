# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog
  include Rockhall::EadSolrMethods

  def show
    ead_id = get_field_from_solr("ead_id",params[:id])
    if ead_id.nil?
      super
    else

      @components = Hash.new
      @components[:first] = get_component_docs_from_solr(ead_id,{ :level => "1"})
      parent_ref_list = get_field_from_solr("parent_ref_list",params[:id])
      unless parent_ref_list.nil?
        parent_ref_list.each do |ref|
          @components[ref.to_sym] = get_component_docs_from_solr(ead_id,{ :parent_ref => ref.to_s})
        end
      end

      params[:id] = ead_id
      super

    end
  end

end
