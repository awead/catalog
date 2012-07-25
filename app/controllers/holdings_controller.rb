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

    if @holdings.join(" ").match("LIB USE ONLY")
      @status = "Copies Available"
    elsif @holdings.first.match("unknown")
      @status = @holdings.first.capitalize
    else
      @status = "Not available"
    end

    if params[:type] == "full"
      render :partial => "holdings/show/full"
    else
      render :partial => "holdings/show/brief"
    end
  end




end