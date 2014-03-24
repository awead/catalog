# Ead Behaviors
#
# A collection of instance methods used by our custom Component and Document
# modules.  They're helpful for doing fancy things with the data when it gets
# indexed into solr.

module Rockhall::Ead::Behaviors

  # Returns an array of individual accession numbers for indexing the solr.
  #
  # Using the xml node in the ead with information about accession numbers, it tokenizes
  # the string based on either whitespace, commas or semicolons and determines if each
  # token matches the format of our accession numbers. Ranges of accession numbers that
  # are formatted correctly will be interpolated. For example, the ead node with this
  # text:
  #
  #   This collection includes A1994.34.4 and A1994.34.7-A1994.34.9
  #
  # Would result in the array:
  #
  #   ["A1994.34.4", "A1994.34.7", "A1994.34.8", "A1994.34.9"]
  def ead_accession_range(input, results = Array.new)
    return results if input.nil?
    input.split(/[\s,;]/).each do |token|
      unless token.match(/^\w\d{4,4}/).nil?
        token.match(/-/) ? results.push(compute_range(token)) : results.push(token)
      end
    end
    return results.flatten
  end

  # Attempts to interpolate accession numbers from different ranges.  The results are
  # returned as an array of individual accession numbers that can be indexed and searched in
  # solr.  For example, ranges that are shown in the ead as:
  #
  #   A1994.34.19-A1994.34.30
  #
  # Will be broken down into individual accession number and stored in solr as:
  #
  #   ["A1994.34.19", "A1994.34.20", "A1994.34.21", ... "A1994.34.30"]
  #
  # Requirements:
  #   range must be separated by a single dash without any spaces
  #
  # Limitations:
  #   can accomodate ranges with letters such as A2001.93.2a-A2001.93.2c but both letters
  #   and numbers such as  A2001.93.4a-A2001.93.5b
  #
  #   numeric ranges are limited to the final tuple, or numbers after the last period
  def compute_range(range, accessions = Array.new)
    return accessions if range.nil?
    first, last = range.split(/-/)
    fparts = first.strip.split(/\./)
    lparts = last.strip.split(/\./)
    (fparts[2]..lparts[2]).each { |n| accessions << fparts[0] + "." + fparts[1] + "." + n }
    return accessions
  end

  # Formats multiple data fields into a single field for display
  def ead_date_display(parts = Array.new)
    unless self.unitdate.empty?
      parts << self.unitdate
    else
      unless self.unitdate_inclusive.empty? and self.unitdate_bulk.empty?
        parts << "Inclusive,"
        parts << self.unitdate_inclusive
        unless self.unitdate_bulk.empty?
          parts << ";"
          parts << self.unitdate_bulk
        end
      end
    end
    return parts.join(" ")
  end

  # Returns the language terms as string from a given three-letter code found in language_map.properties
  def get_language_from_code code, properties = Hash.new
    file = File.new(File.path(Rails.root + "vendor/SolrMarc/translation_maps/language_map.properties"))
    IO.foreach(file) do |line|
      properties[$1.strip] = $2 if line =~ /([^=]*)=(.*)\/\/(.*)/ || line =~ /([^=]*)=(.*)/
    end
    properties[code].nil? ? nil : properties[code].strip
  end

  # Split-up subject terms like we do for our marc records
  def get_ead_subject_facets terms = Array.new
    self.subject.each do |term|
      splits = term.split(/--/)
      terms << splits
    end
    return terms.flatten.compact.uniq.sort
  end

  # Combine corporate and personal names into one group
  def get_ead_names
    (self.corpname + self.persname).flatten.compact.uniq.sort
  end

  # Returns a hash of lanuage fields for an EAD document or component
  def ead_language_fields fields = Hash.new
    language = get_language_from_code(self.langcode.first)
    unless langcode.nil?
      Solrizer.set_field(fields, "language", language, :facetable)
      Solrizer.set_field(fields, "language", language, :displayable)
    end
    return fields
  end

end
