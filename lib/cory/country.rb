require 'i18n'

module Cory
  class Country
    attr_accessor :normaliser
    def initialize(data) # first: alpha-2 code, remainder: synonyms
      I18n.available_locales = [:en]
      #binding.pry
      @code = data.to_a.shift.downcase
      raise unless @code
      @synonyms = data.collect{|d| clean(d) if d}
      # Normalising factor, could be e.g. population, area, gdp etc
      @normaliser = false
    end
    def add(synonym)
      @synonyms = @synonyms + [ clean(synonym) ].flatten
    end
    def synonyms
      return [@code]+@synonyms
    end
    def match?(string)
      #simple_string = string.gsub(/[\.\,]/,'')
      #binding.pry if @code==''
      #binding.pry if string =~ /icro/ && @code=='fm'
      synonyms.include? clean(string)
    end
    def to_s
      @code
    end
    def name
      @synonyms[2] || @code
    end

    private

    def clean(synonym)
      # Gotchas:
      # . denoting abbreviations
      # ’ sexed and sexless (d'Ivoire)
      # , in reordered names (Congo, Rep. of)
      # Accented characters in general
      I18n.transliterate synonym.strip.gsub(/[\.\,\’\']/,'').downcase
    end
  end
  
  class Countries
    include Logging
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
    def get(name) # fetch country object
      @countries.each { |c| return c if c.match? name }
      #log.warn "#{name} not found"
      nil
    end
    def normalise(file, headers=false)
      normal_data = CSV.read file, headers: headers
      normal_data.each do |row|
        # row is a CSV object, not an array
        name,data = row[0],row[1]
        country = get(name)
        if country
          #binding.pry
          country.normaliser = data.to_f
        else
          # We have normalisation data for a country not in the dataset:
          # this is completely normal and almost certainly not noteworthy
          # We do NOT catch countries that haven't been normalised here
          #puts "No data to normalise #{name}"
          #log.debug "No data to normalise #{name}"
        end
      end
      unnormalised = @countries.select { |c| !c.normaliser }
      unless unnormalised.empty?
        puts "Unnormalised countries:"
        unnormalised.each { |c| puts "  #{c.name}"}
      end
    end
  end
end