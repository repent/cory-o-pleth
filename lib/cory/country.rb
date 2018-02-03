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
    # find(string)
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
      load_data
    end
    def find(string) # fetch country object
      @countries.each { |c| return c if c == string }
      nil
    end

    private

    # Normalisation
    # -N requests data is normalised (divided) by a factor such as population, area, gdp etc
    # It is generally (though not always) good practice to normalise data for choropleth maps

    def normalise # using normalisation data in CSV in options
      log.debug "Normalising countries from CSV file"
      CSV.read("#{@options.normalisation_data}/#{@options.normalise}.csv", headers: @options.normalisation_data_header).each do |country_code, normalisation_number|
          find(country_code).normaliser = normalisation_number.to_f
        end
      end
    end
    def dont_normalise
      log.debug "Using unnormalised data"
      @countries.each { |c| c.normaliser = false }
    end
    def load_data # from CSV
      # TODO: load data from WB
      @unrecognised_country_names = []
      CSV.read(@options.input_data, headers: @options.input_data_header).each do |row|
        country_name, data_point = row[0].strip, row[1].strip # Ignore subsequent rows
        unless data_point.numeric?
          log.warn "Discarding non numeric data (#{data_point}) for #{country_name}"
          next
        end
        # Check that we understand the country given
        country = @countries.find country_name
        unless country
          log.warn "I have not heard of a country called #{country_name}, so I'm ignoring it"
          @unrecognised_country_names.push country_name
          next
        end
        # Add data to country objects
        country.raw_data = data_point.to_f
      end

    # Junk no longer needed

    def translate(name)
      raise "Deprecated"
      @countries.each do |c|
        return c.to_s if c.match? name
      end
      log.warn("Do not recognise country in source data: #{name} (dropping this data point!)")
      false
    end
    #def has?(country)
    #  translate(country) ? true : false
    #end

    # Set @normaliser for each Country
    # DEPRECATED?
    #def normalise(file, headers=false)
    #  raise "Deprecated"
    #  normal_data = CSV.read file, headers: headers
    #  normal_data.each do |row|
    #    # row is a CSV object, not an array
    #    name,data = row[0],row[1]
    #    country = get(name)
    #    if country
    #      #binding.pry
    #      country.normaliser = data.to_f
    #    else
    #      # We have normalisation data for a country not in the dataset:
    #      # this is completely normal and almost certainly not noteworthy
    #      # We do NOT catch countries that haven't been normalised here
    #      #puts "No data to normalise #{name}"
    #      #log.debug "No data to normalise #{name}"
    #    end
    #  end
    #  unnormalised = @countries.select { |c| !c.normaliser }
    #  unless unnormalised.empty?
    #    log.info "Countries that are recognisable to Cory but don't have normalisation data:" + unnormalised#.collect { |c| "#{c.name}" }.join(', ')
    #  end
    #end
  end
  class Country
    include Logging
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
      @short_name = csv.shift
      @alpha_2 = csv.shift
      @alpha_3 = csv.shift
      @numerical = csv.shift
      # other_synonyms are not stored in a human-readable format, and are for matching only
      # nil.to_s == ''
      @other_synonyms = csv.reject { |e| e.to_s.empty? }.collect { |e| clean(e) } + clean(@short_name)
      # Arguably don't need @short_name but something has probably gone wront if it's not there
      raise "Insufficient data in country name file" unless @short_name and @alpha_2
      @raw_data = nil
      # E.g. population, gdp, area etc
      @normaliser = nil
    end
    #def add(synonym)
    #  @synonyms = @synonyms + [ clean(synonym) ].flatten
    #end
    def to_s
      @short_name
    end
    alias_method :name, :to_s
    def ==(other)
      # duck type: does it match other.to_s
      match_synonyms.include? clean(other.to_s)
    end
    def <=>(other)
      data_point <=> other.to_f
    end
    def data_point
      # Can we check if we are meant to be normalising?
      raise "#{to_s} has not been told whether to normalise data yet" if @normaliser == nil
      raise "Method not written"
    end
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
      [ @alpha_2, @alpha_3, @numerical, @other_synonyms ].flatten
    end
  end
end