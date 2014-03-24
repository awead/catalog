class ComponentsController < ApplicationController

  include Rockhall::Solr::ComponentQueries
  
  def index
    @numfound, @components = get_componets_for_index_view
    if request.xhr?
      render :partial => "components/row" 
    else
      respond_to do |format|
        format.html
        format.js { render :partial => "components/row" }
      end
    end
  end

  private

  def get_componets_for_index_view
    if params[:ref]
      ead_components_from_parent(params[:id], params[:ref], {:start => params[:start], :rows => params[:rows]})
    else
      first_level_ead_components(params[:id], {:start => params[:start], :rows => params[:rows]})
    end
  end

end
