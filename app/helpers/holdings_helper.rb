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

  def show_holdings(doc = @document, opts={})
    if doc[:innovative_display]
      case doc[:format]
        when "Website" then show_website_holdings(opts)
        when "Periodical" then show_periodical_holdings(doc, opts)
        else show_all_holdings(doc, opts)
      end
    end
  end

  def show_website_holdings opts
    return nil
  end

  def show_periodical_holdings doc, opts
    puts @document.inspect
    if opts[:full]
      render :partial => "holdings/show/periodical", :locals => { :holdings => build_holdings_array(doc) }
    else
      render_holdings_link(doc)
    end
  end

  def show_all_holdings doc, opts
    if opts[:full]
      content_tag(:div, nil, :class => "innovative_holdings", :id => doc[:innovative_display].first)
    else
      content_tag(:div, "checking status..." , :class => "innovative_status", :id => doc[:innovative_display].first)
    end
  end

  def build_holdings_array(doc, holdings = Array.new)
    doc[:holdings_location_display].each do |code|
      if code.match(/^rh/)
        h = Rockhall::Holdings.new
        index = doc[:holdings_location_display].index(code)
        h.location    = location[code]
        h.call_number = doc[:lc_callnum_display].first
        h.status      = get_status(index)
        holdings << h
      end
    end
    return holdings
  end

  def render_holdings_link(doc = @document)
    link_to("Click for Holdings", Rockhall::Innovative.link(doc[:innovative_display].first), { :target => "_blank"})
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