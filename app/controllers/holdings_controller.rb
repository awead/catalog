class HoldingsController < ApplicationController

  include Rockhall::Innovative

  # Returns either a brief one-line statement of an item's status:
  # params[:type] = "brief"
  #  -- Copies available
  #  -- Not available
  #  -- Unknown
  # OR
  # Returns a formatted display page containing and item's complete
  # holdings inforamation
  # params[:type] = "full"
  def show
    @holdings = Rockhall::Innovative.get_holdings(params[:id])
    @status = get_status_from_holdings
    params[:type] == "full" ? render(:partial => "holdings/show/full") : render(:partial => "holdings/show/brief")
  end

  def get_status_from_holdings
    if @holdings.join(" ").match("LIB USE ONLY")
      "Copies Available"
    elsif @holdings.first.match("unknown")
      @holdings.first.capitalize
    else
      "Not available"
    end
  end

end
