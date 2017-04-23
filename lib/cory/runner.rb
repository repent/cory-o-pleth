require_relative 'logging'
require_relative 'colour'
require_relative 'country'
require_relative 'options'
require_relative 'colour_range'
require_relative 'scale'
require_relative 'basket'
require_relative 'colorbrewer'
require_relative 'data_catalog'
require_relative 'indicators'
require_relative 'string'
require_relative 'nil'
#require_relative 'datapoint'
require 'csv'
require 'pry'
require 'ap'

# Bugs
# * For some reason Ukraine isn't shaded!

module Cory
  class Runner
    include Logging
    def initialize(argv)
      @options = Options.new(argv)
      @headers = []
      @unrecognised = []
    end

    def run
      # Importing Country Data
      # This is not user-editable
      country_data = CSV.read(@options.country_data)
      country_data.shift # ditch header
      @countries = Countries.new(country_data)
      # End of Country Data

      log.debug "Source: #{@options.source.to_s}"
      log.debug "Input file(s): #{@options.input_data.join(', ')}"
      log.debug "Output file: #{@options.output}"

      if @options.create_map
        create_map
      else
        combine_csv
      end
    end

    def create_map
      raise "Too many input files to create a map (#{@options.input_data.length})" unless @options.input_data.length == 1

      # Importing statistics that will be the basis of country colours
      data = case @options.source
        when :file
          #@options.title = "World Map: #{@options.input_data}"
          log.debug "Reading source data from file #{@options.input_data}"
          data = CSV.read @options.input_data.first

          # Data Cleaning for CSV
          # select! returns nil if no changes were made, so have to use non-destructive version
          # Get rid of header if necessary
          data = data.drop(1) if @options.header_row
          # Get rid of later columns and nil values
          data = data.collect { |d| d.slice(0,2) }.select { |d| d[1] and d[1].strip != '' }
          # Remove unrecognised countries (but remember what the failures were)
          @unrecognised = data.select { |d| !@countries.has? d[0].to_s }.collect { |d| d[0] }
          data = data.select { |d| @countries.has? d[0].to_s }
          # Convert numerical data to floating point (will start off as text if from CSV)
          data = data.collect { |d| d[1] = d[1].to_f_or_nil; d }
          # End of Data Cleaning

        when :wb
          log.debug "Downloading source data from World Bank"
          log.debug "Using dataset #{@options.wb_indicator}"
          dc = DataCatalog.new(@options.wb_indicator, @options.wb_year)
          @options.title = dc.title
          dc.to_a
          # Data Cleaning for WB done in class
      end

      css = []
      circles = @options.circles ? "opacity: 1;" : ""

      case @options.colour_rule
        # Sort data points into n baskets, each containing a similar number, and colour each
        # basket according to a colour explicitly defined in PALETTE
        when :basket
          basket = Basket.import(@options.palette, @options.palette_size)
          basket.reverse! if @options.reverse

          colour_array = basket * data
          colour_array.each do |c|
            #next unless @countries.has? c[0]
            css.push ".#{@countries.translate(c[0])} { fill: ##{c[1].to_hex}; #{circles} }"
          end

        # Give each data point its own colour based on its position between the largest
        # and smallest value
        when :interpolate
          scale = Scale.import(@options.palette, @options.palette_size)
          scale.reverse! if @options.reverse

          colour_array = scale * data
          colour_array.each do |c|
            css.push ".#{@countries.translate(c[0])} { fill: ##{c[1].to_hex}; #{circles} }"
          end
        else
          log.fatal "Unknown colour rule #{@options.colour_rule}"
          exit 1
      end

      # Add additional CSS lines
      # Kill world border and antarctica

css.push <<STATIC_CSS


.aq { fill: none; }
.oceanxx {
   opacity: 1;
   color: #000000;
   fill: #ffffff;
   stroke: #000;
   stroke-width:0; /* default: 0.5 */
   stroke-miterlimit:1;
}
STATIC_CSS

      # Inject CSS into a map
      
      source = File.readlines(@options.map)
      
      if File.exist? @options.output and @options.becareful
        puts "#{@options.output} already exists and 'warn' option has been set, exiting"
        exit
      end
      
      log.info "Writing output to #{@options.output}"
      output = File.new(@options.output, 'w')
      
      source.each do |l|
        if l =~ /^INJECT-CSS/i
          css.each do |m|
            output.puts m
          end
        elsif l =~ /World Map/
          output.puts l.sub(/World Map/, @options.title)
        else
          output.puts l
        end
      end
      print_unrecognised
    end

    def print_unrecognised
      if @options.print_discards
        raise "Unavailable option" if @options.source == :wb
        puts "\nThese countries weren't recognised:" if @unrecognised.length > 0
        @unrecognised.each { |u| puts "   #{u}" }
      end
    end

    def combine_csv
      @options.input_data.each do |input|
        log.debug "Reading source data from file #{input}"
        data = CSV.read input
        # @options.header_row
        headers = data.delete_at 0
        @headers += headers.drop(1)
        raise "Not implemented" unless @options.one_column_per_file

        #binding.pry

        ## Data Cleaning for CSV
        ## select! returns nil if no changes were made, so have to use non-destructive version
        #if @options.one_column_per_file
        #  # Get rid of later columns and nil values
        #  data = data.collect { |d| d.slice(0,2) }.select { |d| d[1] and d[1].strip != '' }
        #end
#
        ## Remove unrecognised countries (but remember what the failures were)
        #unrecognised = data.select { |d| !@countries.has? d[0].to_s }
        #data = data.select { |d| @countries.has? d[0].to_s }
        #
        ## Convert numerical data to floating point (will start off as text if from CSV)
        #data = data.collect { |d| d[1] = d[1].to_f; d }
        ## End of Data Cleaning

        data.each do |c|
          if @countries.has? c[0]
            country = @countries.find(c[0])
            1.upto(c.length+1) do |n|
              country[headers[n]] = c[n].to_f_or_nil
            end
          else
            @unrecognised.push c[0]
          end
        end
      end

      CSV.open @options.output, 'wb' do |csv|
        csv << [ 'Country code' ] + @headers
        @countries.each do |country|
          row = []
          row.push country.to_s
          @headers.each do |header|
            row.push country[header]
          end
          if @options.keep_all or (@options.keep_incomplete_data and any_data?(row)) or
            complete?(row)
            csv << row
          end
        end
      end
      print_unrecognised
    end

    private

    def complete?(row)
      # row = [ country_code, data1, data2, data3 ]
      # return false if there is a nil in there
      row.each { |d| return false unless d }
      true
    end

    def any_data?(row)
      row.drop(1).each { |d| return true if d }
      false
    end
  end
end