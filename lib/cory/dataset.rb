#require 'nokogiri'

module Cory
  class Dataset
    include logging
    def self.parse(countries, options)
      #@countries, @options = countries, options
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
  end
end