class HoldingsController < ApplicationController

  include Rockhall::Innovative

  def index
  end


  def show
    holdings = Rockhall::Innovative.get_holdings(params[:id])
    if holdings.join(" ").match("LIB USE ONLY")
      @status = "Copies Available"
    elsif holdings.first.match("unknown")
      @status = holdings.first.capitalize
    else
      @status = "Not available"
    end
  end




end