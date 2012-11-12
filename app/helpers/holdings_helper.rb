module HoldingsHelper

  include Rockhall::Innovative

  def opac_link(iii_id)
    results = String.new
    link = Rockhall::Innovative.link(iii_id.first.to_s)
    results << "<h5>" + link_to("View in opac", link) + "</h5>"
    return nil
  end

  def show_full_holdings
    show_holdings(@document, {:full=>TRUE})
  end

  def show_holdings(doc, opts={})
    @document ||= doc
    if doc[:innovative_display]
      case doc[:format]
        when "Website" then show_website_holdings(opts)
        when "Periodical" then show_periodical_holdings(opts)
        else show_all_holdings(opts)
      end
    end
  end

  def show_website_holdings opts
    return nil
  end

  def show_periodical_holdings opts
    if opts[:full]
      render :partial => "holdings/show/periodical", :locals => { :holdings => build_holdings_array }
    else
      render_holdings_link
    end
  end

  def show_all_holdings opts
    if opts[:full]
      content_tag(:div, nil, :class => "innovative_holdings", :id => @document[:innovative_display].first)
    else
      content_tag(:div, "checking status..." , :class => "innovative_status", :id => @document[:innovative_display].first)
    end
  end

  def build_holdings_array(holdings = Array.new)
    @document[:holdings_location_display].each do |code|
      if code.match(/^rh/)
        h = Rockhall::Holdings.new
        index = @document[:holdings_location_display].index(code)
        h.location    = location[code]
        h.call_number = @document[:lc_callnum_display].first
        h.status      = get_status(index)
        holdings << h
      end
    end
    return holdings
  end

  def render_holdings_link
    link_to("Click for Holdings", Rockhall::Innovative.link(@document[:innovative_display].first), { :target => "_blank"})
  end

  def get_status(index)
    unless @document[:holdings_status_display].nil?
      status[@document[:holdings_status_display][index]]
    end
  end

  def status
    {
      "o" => "LIB USE ONLY",
      "p" => "In Process",
      "-" => "Check Shelves"
    }
  end

  def location
    {
      "rhlrr" => "Rock Hall Library Reading Room",
      "rhs2"  => "Rock Hall Stacks 2"
    }
  end

end