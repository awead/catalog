# Queries solr for all existing marc records and writes them out to files in mrc format.
# Can be used to re-index existing metdata without having to query Innopac all over again.

class MarcFile

  attr_writer :start, :rows, :path, :split

  def start
    @start || 0
  end

  # This is obscenely high so has to return all the documents in the index
  def rows
    @rows || 1000000000
  end

  def path
    @path || "tmp/out.mrc"
  end

  def split
    @split || 50
  end

  # TODO: get marc_display['' TO *] working so it's just returning the records with the marc_display
  # field and not everything... 
  def get_records query = Hash.new
    query[:qt]    = 'document'
    query[:q]     = 'id:*'
    query[:fl]    = 'marc_display'
    query[:rows]  = self.rows
    query[:start] = self.start
    Blacklight.solr.find(query)["response"]["docs"].collect { |doc| doc unless doc.empty? }.compact
  end

  # TODO: Write to multiple files with :split number of records per file
  def write_out path = String.new
    writer = ::MARC::Writer.new(self.path)
    get_records.each do |doc|
      record = ::MARC::XMLReader.new(StringIO.new(doc["marc_display"])).first
      writer.write(record)
    end
    writer.close
  end

end
