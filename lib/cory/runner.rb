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
#require_relative 'dataset'
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
      # TODO: This now ignores direct access of WB data
      #       Option has been removed for now/ever
      countries = Countries.new(@options)

      #  when :wb
      #    log.debug "Downloading source data from World Bank"
      #    log.debug "Using dataset #{@options.wb_indicator}"
      #    dc = DataCatalog.new(@options.wb_indicator, @options.wb_year)
      #    @options.title = dc.title
      #    dc.to_a
      #end

      css = [ "\n",
        ".landxx { fill: ##{@options.no_data_colour}; }",
        "\n" ]

      # Assign colours to countries according to the selected rule
      case @options.colour_rule

        # Sort data points into n baskets, each containing a similar number, and colour each
        # basket according to a colour explicitly defined in PALETTE
        when :basket
          # #import pulls in data on colours
          @baskets = Baskets.import(@options)
          # Since rewriting the basket code to output a legend, the colours get reversed.
          # I'm not sure if there is really a "logical" way around embedded in the colour data
          # or not, so not sure if this is an error or just an arbitrary result.  So kludging
          # it here and moving on, woop [unless instead of if].
          @baskets.reverse! unless @options.reverse

          # Distribute countries into baskets
          # Remove countries for which no user data is supplied
          @baskets.fill(countries)

          css << @baskets.to_css

          # Output normalised, basketed data to a HTML log for error-checking
          @baskets.data_summary

        # Give each data point its own colour based on its position between the largest
        # and smallest value
        # Note: this does use @options.palette_size, which defaults to 3
        #       Increasing this would follow colourbrewer more closely
        when :interpolate
          scale = Scale.import(@options)
          scale.reverse! if @options.reverse

          #raise "This won't work."
          #binding.pry

          # Get rid of countries without data
          #countries.discard_dataless!
          countries.compact!

          # Populate countries with colour data
          scale.assign_linear_colours_to(countries)

          # Print css colours
          css += countries.to_css

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
        elsif l =~ /\<\/svg\>/ and @options.graphical_legend and @options.colour_rule == :basket
          @baskets.svg_legend(output)
          output.puts l
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
          if File.exist? @options.text_legend_file and @options.becareful
            puts "#{@options.text_legend_file} already exists and 'warn' option has been set, exiting"
            exit 1
          end
          log.warn "Overwriting #{@options.text_legend_file}"
          legend = File.open(@options.text_legend_file, 'w')
          legend << @baskets.wikipedia_legend
          legend.close
        else
          log.debug "Printing legend"
          print @baskets.print_legend
        end
      end
    end
  end
end