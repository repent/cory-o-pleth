require 'i18n'

# Countries
# countries Array Country objects
# missing   Log   Unfound country names

# Country
# code     String       ISO 2-digit code
# synonyms Array/String Text names for country
# data     Hash/Float   Indicator => number

module Cory
  class Country
    #attr_reader :data

    def initialize(data) # first: alpha-2 code, remainder: synonyms
      I18n.available_locales = [:en]
      #binding.pry
      @code = data.to_a.shift.downcase
      raise unless @code
      @synonyms = data.collect{|d| clean(d) if d}
      @data = {}
    end
    def add(synonym)
      @synonyms = @synonyms + [ clean(synonym) ].flatten
    end
    def synonyms; [@code]+@synonyms; end
    def match?(string)
      #simple_string = string.gsub(/[\.\,]/,'')
      #binding.pry if @code==''
      #binding.pry if string =~ /icro/ && @code=='fm'
      synonyms.include? clean(string)
    end
    def to_s
      @code
    end
    def []=(key,val); @data[key] = val; end
    def [](key); @data[key]; end
    def name; @synonym[0] || @code.upcase; end

    private

    def clean(synonym)
      # Gotchas:
      # . denoting abbreviations
      # ’ sexed and sexless (d'Ivoire)
      # , in reordered names (Congo, Rep. of)
      # Lack of space after . e.g. St.Vincent
      # Accented characters in general
      I18n.transliterate synonym.strip.gsub(/[\.\,\’\' ]/,'').downcase
    end
  end
  
  class Countries
    #include Logging
    def initialize(cd)
      @countries = cd.collect { |i| Country.new(i) }
      @missing = Logger.new('log/country_names_not_found.log')
    end
    def translate(name)
      @countries.each do |c|
        return c.to_s if c.match? name
      end
      @missing.warn(name)
      false
    end
    def has?(country)
      translate(country) ? true : false
    end
    def find(name)
      @countries.each do |c|
        return c if c.match? name
      end
    end
    def each
      @countries.each { |country| yield country }
    end
  end
end