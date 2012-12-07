class ComponentsController < ApplicationController

  include Rockhall::SolrHelperExtension
  
  def index
    @documents = additional_ead_components(params[:ead_id], params[:parent_ref])
  end

end