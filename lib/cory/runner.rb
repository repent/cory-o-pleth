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
require_relative 'dataset'
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
    end

    def run
      # Importing country names, synonyms from CSV, then data
      countries = Countries.new(@options)

      ## Importing data
#
      #log.debug "Reading data from #{@options.source}"
#
      #unrecognised = []
#
      ## Importing statistics that will be the basis of country colours
      ## Data can be drawn from a CSV file or (maybe) the World Bank database
      #data = case @options.source
      #  when :file
      #    # TODO: take map title from header row?
      #    #@options.title = "World Map: #{@options.input_data}"
      #    log.debug "Reading source data from file #{@options.input_data}"
      #    data = CSV.read @options.input_data
#
      #    # Data Cleaning for CSV
      #    # select! returns nil if no changes were made, so have to use non-destructive version
#
      #    # Puts data into countries
      #    countries.load_data
      #    data = Dataset.new(@options, countries)
#
      #    # Get rid of later columns and nil values
      #    data = data.collect { |d| d.slice(0,2) }.select { |d| d[1] and d[1].strip != '' }
      #    # Remove unrecognised countries (but remember what the failures were)
      #    unrecognised = data.select { |d| !countries.has? d[0].to_s }
      #    data = data.select { |d| countries.has? d[0].to_s }
      #    # Convert numerical data to floating point (will start off as text if from CSV)
      #    data = data.collect { |d| d[1] = d[1].to_f; d }
      #    # End of Data Cleaning
#
      #    # Normalisation -- this should be refactored elsewhere
      #    if @options.normalise
      #      # Replace data with normalised data
      #      data = data.collect do |name,data_point|
      #        country = countries.get(name.to_s)
      #        if country.normaliser and country.normaliser != 0.0
      #          data_point = data_point / country.normaliser
      #          raise "Normalised data is infinity" if data_point == Float::INFINITY
      #          [name,data_point]
      #        else
      #          log.error "Couldn't normalise #{name} [normalising by #{@options.normalise}, normaliser #{#country.normaliser.to_s}] -- dropping this datapoint"
      #          nil
      #        end
      #      end
      #      # Drop values set to nil above
      #      data.compact!
      #      #normal = CSV.read "#{@options.normalisation_data}/#{@options.normalise.to_s}.csv"
      #      # Check that all data points can be normalised
#
      #      # Output normalised data for debugging
      #      #CSV.open(@options.normalised_data_log, 'wb') do |csv|
      #      #  data.each { |d| csv << d }
      #      #end
      #    end
#
      #    data
#
      #  when :wb
      #    log.debug "Downloading source data from World Bank"
      #    log.debug "Using dataset #{@options.wb_indicator}"
      #    dc = DataCatalog.new(@options.wb_indicator, @options.wb_year)
      #    @options.title = dc.title
      #    dc.to_a
      #    # Data Cleaning for WB done in class
      #end


      css = [ "\n",
        ".landxx { fill: ##{@options.no_data_colour}; }",
        "\n" ]

      circles = @options.circles ? "opacity: 1;" : ""



      case @options.colour_rule
        # Sort data points into n baskets, each containing a similar number, and colour each
        # basket according to a colour explicitly defined in PALETTE
        when :basket
          @baskets = Baskets.import(@options.palette, @options.palette_size)
          # Since rewriting the basket code to output a legend, the colours get reversed.
          # I'm not sure if there is really a "logical" way around embedded in the colour data
          # or not, so not sure if this is an error or just an arbitrary result.  So kludging
          # it here and moving on, woop [unless instead of if].
          @baskets.reverse! unless @options.reverse

          colour_array = @baskets * data
          colour_array.each do |c|
            #next unless countries.has? c[0]
            css.push ".#{countries.translate(c[0])} { fill: ##{c[1].to_hex}; #{circles} }"
          end

          # Output normalised, basketed data
          CSV.open(@options.normalised_data_log, 'wb') do |csv|
            n = 1
            @baskets.each do |basket|
              # Basket header
              csv << [ "Basket #{n}: #{basket}" ]
              basket.countries.each do |c|
                # These are just country names, not objects
                # I think this has got too complicated for my tiny brain to comprehend
                #binding.pry
                obj = countries.get(c)
                csv << [ obj.name ]
                #binding.pry
              end
              n += 1
            end
            #data.each { |d| csv << d }
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
      if @options.print_discards
        raise "Unavailable option" if @options.source == :wb
        puts "\nThese countries weren't recognised:" if unrecognised.length > 0
        unrecognised.each { |u| puts "   #{u[0]}" }
      end

      if @options.text_legend and (@options.colour_rule == :basket)
        if @options.text_legend == :file
          # Dump to file
          if File.exist? @options.legend_file and @options.becareful
            puts "#{@options.legend_file} already exists and 'warn' option has been set, exiting"
            exit 1
          end
          log.warn "Overwriting #{@options.legend_file}"
          legend = File.open(@options.legend_file, 'w')
          legend << @baskets.print_legend
          legend.close
        else
          log.debug "Printing legend"
          print @baskets.print_legend
        end
      end
    end
  end
end