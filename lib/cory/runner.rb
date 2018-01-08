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
#require_relative 'datapoint'
require_relative 'legend'
require 'csv'
require 'pry'
require 'ap'

module Cory
  class Runner
    include Logging
    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
      #i=Indicators.new
      #binding.pry
      # Importing Country Data
      # This is not user-editable
      log.debug "Area names: #{@options.country_data}"
      country_data = CSV.read(@options.country_data)
      country_data.shift # ditch header
      countries = Countries.new(country_data)
      # End of Country Data

      log.debug "Source: #{@options.source}"

      unrecognised = []

      #######################
      # Put data into order #
      #######################

      # Importing statistics that will be the basis of country colours
      data = case @options.source
        when :file
          #@options.title = "World Map: #{@options.input_data}"
          log.debug "Reading source data from file #{@options.input_data}"
          data = CSV.read @options.input_data

          # Data Cleaning for CSV
          # select! returns nil if no changes were made, so have to use non-destructive version
          # Get rid of later columns and nil values
          data = data.collect { |d| d.slice(0,2) }.select { |d| d[1] and d[1].strip != '' }
          # Remove unrecognised countries (but remember what the failures were)
          unrecognised = data.select { |d| !countries.has? d[0].to_s }
          data = data.select { |d| countries.has? d[0].to_s }
          # Convert numerical data to floating point (will start off as text if from CSV)
          data = data.collect { |d| d[1] = d[1].to_f; d }
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


      # Use the colour rule to construct CSS

      case @options.colour_rule
        # Sort data points into n baskets, each containing a similar number, and colour each
        # basket according to a colour explicitly defined in PALETTE
        when :basket
          basket = Basket.import(@options.palette, @options.palette_size)
          basket.reverse! if @options.reverse

          colour_array = basket * data
          colour_array.each do |c|
            #next unless countries.has? c[0]
            css.push ".#{countries.translate(c[0])} { fill: ##{c[1].to_hex}; #{circles} }"
          end

        # Give each data point its own colour based on its position between the largest
        # and smallest value
        when :interpolate
          scale = Scale.import(@options.palette, @options.palette_size)
          scale.reverse! if @options.reverse

          colour_array = scale * data
          colour_array.each do |c|
            css.push ".#{countries.translate(c[0])} { fill: ##{c[1].to_hex}; #{circles} }"
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
        if l =~ /^\/\* INJECT-CSS \*\//i
          css.each do |m|
            output.puts m
          end
        elsif l =~ /World Map/
          output.puts l.sub(/World Map/, @options.title)
        elsif l =~ /<!-- INJECT-LEGEND -->/i
          legend = Legend.new(@options, basket)
          output.puts legend.to_s
        else
          output.puts l
        end
      end
      if @options.print_discards
        raise "Unavailable option" if @options.source == :wb
        puts "\nThese countries weren't recognised:" if unrecognised.length > 0
        unrecognised.each { |u| puts "   #{u[0]}" }
      end
    end
  end
end