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
      render :partial => "holdings/show/periodical"
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

  def build_periodical_holdings(results = Array.new)
    @document[:holdings_location_display].nil? ? results.push("") : results.push(@document[:holdings_location_display].first)
    @document[:lc_callnum_display].nil? ? results.push("") : results.push(@document[:lc_callnum_display].first)
    @document[:holdings_status_display].nil? ? results.push("") : results.push(@document[:holdings_status_display].first)
  end

  def render_holdings_link
    link_to("Click for Holdings", Rockhall::Innovative.link(@document[:innovative_display].first), { :target => "_blank"})
  end

end