module HoldingsHelper

  include Rockhall::Innovative

  def show_full_holdings
    show_holdings @document, {:full=>TRUE}
  end

  def show_holdings doc = @document, opts={}
    if doc.get Solrizer.solr_name("innovative", :displayable)
      case doc.get(Solrizer.solr_name("format", :displayable))
        when "Website" then nil
        when "Periodical" then render_holdings_link(doc)
        else render_holdings(doc.get(Solrizer.solr_name("innovative", :displayable)), opts)
      end
    end
  end

  private
  
  def render_holdings id, opts
    if opts[:full]
      content_tag :div, nil, :class => "innovative_holdings", :id => id
    else
      content_tag :span, "checking status..." , :class => "innovative_status label label-default", :id => id+"_status"
    end
  end

  def render_holdings_link doc = @document
    link_to "Click for Holdings", 
      Rockhall::Innovative.link(doc.get(Solrizer.solr_name("innovative", :displayable))), 
      {:target => "_blank"}
  end

end
