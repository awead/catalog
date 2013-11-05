module GoogleBooksHelper

  def render_book_cover
    unless @document[Solrizer.solr_name("isbn", :displayable)].nil?
      link = image_link_from_isbn
      image_tag(link) unless link.nil?
    end
  end

  def image_link_from_isbn
    @document[Solrizer.solr_name("isbn", :displayable)].each do |isbn|
      results = ::GoogleBooks.search({:isbn => isbn})
      if results.total_items > 0
        results.each do |book|
          return book.image_link unless book.image_link.nil?
        end
      end
    end
  end

end