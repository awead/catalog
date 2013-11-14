module HoldingsHelper

  include Rockhall::Innovative

  def show_full_holdings
    show_holdings @document, {:full=>TRUE}
  end

  def show_holdings doc = @document, opts={}
    if doc.get Solrizer.solr_name("innovative", :displayable)
      case doc.get(Solrizer.solr_name("format", :displayable))
        when "Website" then show_website_holdings(opts)
        when "Periodical" then show_periodical_holdings(doc, opts)
        else show_all_holdings(doc.get(Solrizer.solr_name("innovative", :displayable)), opts)
      end
    end
  end

  def show_website_holdings opts
    return nil
  end

  def show_periodical_holdings doc, opts
    if opts[:full]
      render :partial => "holdings/show/periodical", :locals => { :holdings => build_holdings_array(doc) }
    else
      render_holdings_link(doc)
    end
  end

  def show_all_holdings id, opts
    if opts[:full]
      content_tag :div, nil, :class => "innovative_holdings", :id => id
    else
      content_tag :span, "checking status..." , :class => "innovative_status badge", :id => id
    end
  end

  def build_holdings_array doc, holdings = Array.new
    doc[Solrizer.solr_name("holdings_location", :displayable)].each do |code|
      if code.match(/^rh/)
        h = Rockhall::Holdings.new
        index = doc[Solrizer.solr_name("holdings_location", :displayable)].index(code)
        h.location    = location[code]
        h.call_number = doc.get(Solrizer.solr_name("lc_callnum", :displayable))
        h.status      = get_status(index)
        holdings << h
      end
    end
    return holdings
  end

  def render_holdings_link doc = @document
    link_to "Click for Holdings", 
      Rockhall::Innovative.link(doc.get(Solrizer.solr_name("innovative", :displayable))), 
      {:target => "_blank"}
  end

  def get_status index
    unless @document[Solrizer.solr_name("holdings_status", :displayable)].nil?
      status[@document[Solrizer.solr_name("holdings_status", :displayable)][index]]
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