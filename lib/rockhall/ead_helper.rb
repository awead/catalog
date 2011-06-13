module Rockhall::EadHelper

  require 'rexml/document'
  include REXML

  # TODO: put these in a config of some kind?
  # These are just displayed at the top of the page and don't have a
  # corresponding entry in the table of contents
  def ead_head_xpaths
    [
      ['Title',                   '/ead/eadheader/filedesc/titlestmt/titleproper',               :text  ],
      ['Repository',              '/ead/archdesc/did/repository/corpname',                       :text  ],
      ['Publisher',               '/ead/eadheader/filedesc/publicationstmt/address/addressline', :tblock ],
      ['Extent',                  '/ead/archdesc/did/physdesc/extent',                           :text  ],
      ['Bulk Date',               '/ead/archdesc/did/unitdate[@type="bulk"]',                    :text  ],
      ['Inclusive Dates',         '/ead/archdesc/did/unitdate[@type="inclusive"]',               :text  ],
      ['Language of Finding Aid', '/ead/eadheader/profiledesc/langusage',                        :text  ],
      ['Language of Collection',  '/ead/archdesc/did/langmaterial/language/@langcode',           :text  ]
    ]
  end

  def ead_xpaths
    [
      ['Abstract',                   '/ead/archdesc/did/abstract',    :text     ],
      ['Biography/History',          '/ead/archdesc/bioghist',        :bioghist ],
      ['Preferred Citation',         '/ead/archdesc/prefercite',      :p        ],
      ['Provenance',                 '/ead/archdesc/acqinfo',         :p        ],
      ['Use Restrictions',           '/ead/archdesc/userestrict',     :p        ],
      ['Access Restrictions',        '/ead/archdesc/accessrestrict',  :p        ],
      ['Processing Information',     '/ead/archdesc/processinfo',     :p        ],
      ['Controlled Access Headings', '/ead/archdesc/controlaccess/*', :acshed   ],
      ['Collection Inventory',       '/ead/archdesc/dsc',             :dsc      ]
    ]
  end

  def dig_message
    results = String.new
    if @document['dao_b']
      results << "<li><span class=\"dao\">There is digital content available for this collection guide.</span></li>"
    end
  end

  def gen_info(xml)
    results = String.new
    results << "<table>"
    ead_head_xpaths.each do |xpath|
      results << "<tr>"
      results << "<td><b>" + xpath[0] + "</b></td>"
      content = xml.xpath(xpath[1]).first
      if content
        xpath_type = xpath[2]
        if xpath_type == :text
          results << "<td>" + content.text + "</td>"
        elsif xpath_type == :tblock
          results << "<td>" + ead_tblock(@document, xpath[1]) + "</td>"
        else
          results << "<td>" + ead_head(content) + "</td>"
        end
      end
      results << "</tr>"
    end
    results << "</table>"
  end

  # TODO: this method isn't working yet
  def ead_body_content(xml)

    ead_xpaths.each do |xpath|
      content = xml.xpath(xpath[1]).first
      if content
        link_id = content.attribute('id') || xpath[1].split('/').last
        puts "<h2 id=\"" + Rockhall::EadMethods.ead_link_id(content, xpath[1]) + "\">" + xpath[0] + "</h2>"
        xpath_type = xpath[2]
        if xpath_type == :p
          ead_paragraphs(content)
        elsif xpath_type == :text
          return "<p>" + content.text + "</p>"
        elsif xpath_type == :acshed
          ead_tblock(@document, xpath[1])
        elsif xpath_type == :bioghist
          render :partial => 'catalog/_show_partials/_ead/chronlist', :locals => {:element => content}
          ead_paragraphs(content)
          render :partial => 'catalog/_show_partials/_ead/sources', :locals => {:element => content}
        elsif xpath_type == :dsc
          render :partial => 'catalog/_show_partials/_ead/dsc', :locals => {:element => content, :start => 'c01'}
        end
      end
    end

  end




  def ead_list(list)
    ol = ['<ol>']
    list.xpath('item').map do |item|
      ol << '<li>' + item.text + '</li>'
    end
    ol << '</ol>'
    ol.join('')
  end

  def ead_tblock(file, path)
    lines = []
    xmldoc = Rockhall::EadMethods.ead_rexml(file)
    results = ead_results(xmldoc, path)
    results.each do |l|
      str = l.to_s
      str.gsub(/<\/?[^>]*>/, "")
      lines << str + "<br />"
    end
    lines.join("")
  end

  def ead_results(xmldoc, path)
    results = XPath.each(xmldoc, path) { |e| }
  end


  def ead_contents(document)
    xml = Rockhall::EadMethods.ead_xml(document)
    xpaths = ead_xpaths
    links = []
    xpaths.each do |pair|
      element = xml.xpath(pair[1]).first
      if element
        link_target = element.attribute('id') || pair[1].split('/').last
        #TODO add digital content
        links << link_to(pair[0], '#' + link_target) if link_target
      end
    end
    return links
  end


  def dao(did, limit=4)
    dao = did.xpath('../dao')[0]
    if dao
      href = dao.attribute('href').text
      regex = /http:\/\/insight.+?Classification%20Number%7C1%7C((UA|MC|ua|mc)([0-9]{3}.){2}[0-9]{3}).+?gc=0/
      if href.match(regex)
        thumbnails, number_of_docs = classification_number_thumbnails($1, :limit => limit)
        if thumbnails
          return_string = '<div class="dao">' + thumbnails
          return_string << classification_see_more_link($1) if number_of_docs > limit
          return_string << '</div>'
        end
      else
        return ''
      end
    else
      return ''
    end
  end

end
