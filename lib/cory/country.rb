require 'i18n'
require 'csv'

module Cory
  class Countries
    include Logging
    include Enumerable
    ##################################################################################
    # Data structure
    #
    # countries (array)
    #
    # Methods
    # 
    # search(string) # find() reserved for Enumerable
    #
    # private
    # 
    # load_data # from CSV
    # normalise
    # dont_normalise
    #
    # translate() to canonical name?
    # has?(string) # just use get?
    # raw
    ##################################################################################

    def initialize(options)
      @options = options
      @countries = CSV.read(@options.country_data, headers: @options.country_data_header).collect { |c| Country.new(c, options) }
      if @options.normalise then normalise else dont_normalise end
      case @options.source
      when :file
        load_data_from_csv
      when :wb
        raise "Not written yet."
      else
        raise "Unknown source."
      end
    end
    # find is an automatic function in Enumerable
    def search(string) # fetch country object
      string.strip!
      # Returns @countries
      @countries.each do |c|
        return c if c == string
      end
      #puts "Did not find #{string}"
      nil
    end
    # Tediously copying over array formulae, almost as if Countries should have been subclassed
    # from Array
    def sort!; @countries.sort!; end
    def length; @countries.length; end
    # Remove countries with no RAW data
    def compact!
      @countries = @countries.reject { |c| c.empty? }
    end
    def reject!(&block)
      @countries.reject!(&block)
    end
    def reverse!; @countries.reverse!; end
    # sizes is an array of sizes of each slice that should be returned
    # the sum of all sizes must equal the length of the array.
    #
    # E.g.
    # a = 1.upto(10).to_a
    # => [1,2,3,4,5,6,7,8,9,10]
    # a.into_slices [ 3, 4, 3 ]
    # => [ [1,2,3],
    #      [4,5,6,7],
    #      [8,9,10]
    #    ]
    def into_slices(sizes)
      raise "Incorrect number of slices" unless @countries.length == sizes.inject(0, :+)
      slices = []
      start = 0
      sizes.each do |size|
        slices.push @countries.slice(start, size)
        start += size
      end
      slices
    end

    private

    # Normalisation
    # -N requests data is normalised (divided) by a factor such as population, area, gdp etc
    # It is generally (though not always) good practice to normalise data for choropleth maps

    def normalise # using normalisation data in CSV in options
      log.debug "Normalising countries from CSV file: reading #{@options.normalisation_data}/#{@options.normalise}.csv"
      # If the CSV file has headers, .each will yield CSV::Row objects (1 per line)
      # If no headers, .each will yield an array representing the row (hopefully with 2 elements)
      CSV.read("#{@options.normalisation_data}/#{@options.normalise}.csv", headers: @options.normalisation_data_header).each do |country_code, normalisation_number|
        # Catch CSV::Row
        if country_code.class == CSV::Row
          country_code, normalisation_number = country_code[0], country_code[1]
        end
        # Error: normalisation data may contain countries not in the main country database, in which
        # case search() will return nil
        country = search country_code
        if country
          country.normaliser = normalisation_number.to_f
        else
          log.error "Country #{country_code} not found in country database -- consider adding it to #{@options.country_data} and creating a pull request.  For now this normalisation data will be discarded (this does NOT mean that any of your data is being discarded)."
        end
      end
    end
    def dont_normalise
      log.debug "Using unnormalised data"
      @countries.each { |c| c.normaliser = false }
    end
    def load_data_from_csv
      # TODO: load data from WB
      @unrecognised_country_names = []
      CSV.read(@options.input_data, headers: @options.input_data_header).each do |row|
        # Could be nil at this point
        country_name, data_point = row.slice(0,2) # Ignore subsequent rows
        unless data_point and data_point.numeric?
          # TODO: currently discards numbers with commas
          log.warn "Discarding non numeric data (#{data_point}) for '#{country_name}'"
          next
        end
        # Check that we understand the country given
        country = search country_name
        unless country
          log.warn "I have not heard of a country called '#{country_name}', so I'm ignoring it"
          @unrecognised_country_names.push country_name
          next
        end
        # Add data to country objects
        country.raw_data = data_point.to_f
      end
    end

    # Junk no longer needed

    #def translate(name)
    #  raise "Deprecated"
    #  @countries.each do |c|
    #    return c.to_s if c.match? name
    #  end
    #  log.warn("Do not recognise country in source data: '#{name}' (dropping this data point!)")
    #  false
    #end
  end

  class Country
    include Logging
    include Comparable
    ##################################################################################
    # Data structure:

    # name (preferred display name)
    # names/codes
    #  alpha_2
    #  alpha_3
    #  numerical
    # normaliser (country needs to be told whether to normalise or not before reporting data)
    # raw_data
    #  data_point (pseudo)
    # 
    # (compare by stripping all spaces, punctuation and downcasing everything)

    ##################################################################################
    # Methods:

    # <=>
    # to_s
    # ==(other) # country or string    
    ##################################################################################

    #attr_accessor :normaliser
    attr_writer :normaliser, :raw_data
    attr_reader :alpha_2, :numerical
    def initialize(csv, options) # first: alpha-2 code, remainder: synonyms
      # Format for input array:
      # 1: English short name
      # 2: alpha-2 (needed for map output)
      # 3: alpha-3
      # 4: numerical
      # 5 onwards: synonyms (first of which usually WBDI name, but don't count on it)
      # store everything except [1] as lower case
      @options = options
      I18n.available_locales = [:en]
      # Gotcha:
      # If country-codes.csv has a header, this will be a hashlike CSV object
      # If country-codes.csv doesn't have a header, csv will be a simple array
      # So, convert to an array if necessary
      if csv.is_a? CSV::Row then csv = csv.collect{ |i| i[1] } end
      @short_name = csv.shift
      @alpha_2 = csv.shift
      @alpha_3 = csv.shift
      @numerical = csv.shift
      # other_synonyms are not stored in a human-readable format, and are for matching only
      # nil.to_s == ''
      @other_synonyms = csv.reject { |e| e.to_s.empty? }.collect { |e| clean(e) } + [ clean(@short_name) ]
      # Arguably don't need @short_name but something has probably gone wront if it's not there
      raise "Insufficient data in country name file" unless @short_name and @alpha_2
      @raw_data = nil
      # E.g. population, gdp, area etc
      @normaliser = nil
    end
    #def add(synonym)
    #  @synonyms = @synonyms + [ clean(synonym) ].flatten
    #end
    def to_s; @short_name; end
    alias_method :name, :to_s
    def ==(other)
      # duck type: does it match other.to_s
      # clean has to be applied to both sides of the comparison
      match_synonyms.include? clean(other.to_s)
    end
    def <=>(other)
      raise "Comparing countries with incomplete data" if data_point == nil or other.data_point == nil
      data_point <=> other.to_f
    end
    def data_point
      # Can we check if we are meant to be normalising?
      if @normaliser == nil
        # This country hasn't been told whether to normalise yet.
        # This means EITHER:
        #   1. There is no normalisation data (population, area etc) for this country), even though it
        #      exists in the country synonyms file (OKAY)
        #   2. There is no normalisation data for this country, even though it exists in the user data (BAD)
        #   3. Something else has gone wrong (BAD)
        # (1) should have been eliminated by compact in Countries#fill, leaving only badness

        # TODO: each of these warnings flashes up every time data_point is called, i.e. about 6 times
        log.warn "#{to_s} has not been told whether to normalise data yet"
        case @options.normalise
        when false
          raise "#{to_s} should have been told that no countries are being normalised."
        when Symbol # usually :population, :area or :gdp
          log.error "Normalisation dataset for #{@options.normalise.to_s} does not contain #{to_s}!  This data point cannot be included in your map, sorry.  Discarding."
          return nil # so that this country can be deleted
        else
          raise "Unexpected value for options.normalise: #{@options.normalise}"
        end
      end
      return nil unless @raw_data
      if @normaliser
        @raw_data / @normaliser
      else
        @raw_data
      end
    end
    def data_summary
      "<tr><td>#{@short_name}</td><td>#{@raw_data}</td><td>#{@normaliser}</td><td>#{data_point}</td></tr>"
    end
    def empty?; !@raw_data; end
    alias_method :to_f, :data_point

    ##################################################################################
    private

    # Store synonyms without accents, punctuation and spaces for forgiving matching
    def clean(synonym)
      # Gotchas:
      # . denoting abbreviations
      # ’ sexed and sexless (d'Ivoire)
      # , in reordered names (Congo, Rep. of)
      # Accented characters in general
      I18n.transliterate synonym.strip.gsub(/[\.\,\’\'\s]/,'').downcase
    end
    def match_synonyms
      [ @alpha_2, @alpha_3, @numerical, @other_synonyms ].flatten.collect { |s| clean(s) }
    end
  end
end