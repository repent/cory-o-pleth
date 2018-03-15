require 'optparse'
require 'ostruct'

module Cory
  class Options
    include Logging
    attr_accessor :verbose, :circles, :input_data, :input_data_header, :country_data, :country_data_header, :colour_rule, :output, :becareful, :map, :palette, :palette_size, :reverse, :logfile, :wb_indicator, :wb_year, :source, :title, :print_discards, :text_legend, :normalise, :normalisation_data, :normalisation_year, :normalisation_data_header, :normalised_data_log, :no_data_colour, :text_legend_file, :graphical_legend, :legend_unit, :wikipedia_number_format

    def initialize(argv)
      @verbose = false
      ###############################
      #### Default configuration ####
      ###############################

      # These are overridden by command line options

      # Display options
      @circles = true
      # Interpolate selects the closest colour from a pseudo-linear scale
      # Basket arranges data points into baskets which are all marked with the same colour
      @colour_rule = :interpolate # c.f. basket
      # Available colour sets: :traffic_lights
      @palette = :OrRd
      @palette_size = 3
      @reverse = false
      @text_legend = :file
      @text_legend_file = false
      @graphical_legend = true
      @legend_unit = nil
      @no_data_colour = '#e0e0e0'
      @wikipedia_number_format = :crap

      # Set this true if you don't want to overwrite files without asking
      @becareful = false
      log.level = Logger::DEBUG
      @logfile = 'log/cory.log'
      #log.fatal "Hahahaha"

      # Data options
      @source = :file
      @wb_indicator = 'NV.IND.TOTL.ZS'
      @wb_year = :latest
      @title = "World Map"
      @print_discards = false

      # Default file locations and options
      @input_data = 'stats/data.csv'
      @input_data_header = false
      @country_data = 'data/country-codes.csv'
      @country_data_header = true
      @output = false
      @map = 'maps/BlankMap-World6-cory.svg'
      @normalisation_data = 'normalise'
      @normalisation_data_header = true
      @normalised_data_log = false #'normalise/normalised_data.html'
      #@map = 'maps/BlankMap-World8-cory.svg'

      # Normalisation
      @normalise = false # :population, :area, :gpp
      @normalisation_year = :latest
      
      ###############################
      ###############################
      ###############################

      parse(argv)      
      #@options = OpenStruct.new(
      #  verbose: false,
      #  # dry: false,
      #  # Display options
      #  circles: true,
      #  input_data: 'data.csv',
      #  country_data: 'country-codes.csv',
      #  colour_rule: :interpolate, # c.f. basket
      #  output: 'output.svg',
      #  becareful: false,
      #  colour_set: :traffic_lights,
      #  map: 'BlankMap-World8-cory.svg',
      #)
      #parse(argv)
    end

    #colours = ['#edf8b1','#7fcdbb','#2c7fb8']
    
    #log.debug("Parsing options")

    #def legend_file
    #  @output.gsub /\.svg$/, '.txt'
    #end

    def circles_css
      circles ? "opacity: 1;" : ""
    end

    def die(message)
      log.fatal message
      $stderr.puts message
      exit 1
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: #{$0} [options] input"
        
        opts.on('-b[NUMBER]', '--basket[=NUMBER]', 'Group countries into NUMBER of discrete baskets (otherwise: linear-ish interpolation, see docs)') do |n|
          @colour_rule = :basket
          @palette_size  = n || @palette_size
        end
        opts.on('-B', '--blank-colour COLOUR', 'Set colour of countries with no data to the hex COLOUR (default is e0e0e0)') do |c|
          log.debug "Setting colour for countries with no data to ##{c.strip}"
          @no_data_colour = c.strip
        end
        opts.on('-c', '--countries FILE', 'Take country name data from FILE (a CSV file)') { |f| @country_data = f }
        #opts.on('--list-colours', 'List available colour sets') { }
        opts.on('-d', '--print-discards', "Print country names that aren's matched") { @print_discards = true }
        opts.on('-h', '--help', 'Print this help') { puts opts; exit }
        opts.on('-H', '--header', 'CSV input file contains a header row') { @header_row = true }
        #opts.on('-i', '--input FILE', 'Take choropleth data from FILE (a CSV file)') { |f| @input_data = f }
        opts.on('-l', '--log LEVEL', 'Set log level (from debug, info, warn, error, fatal)') do |level|
          log.level = case level
            when 'debug', 4
              Logger::DEBUG
            when 'info', 3
              Logger::INFO
            when 'warn', 2
              Logger::WARN
            when 'error', 1
              Logger::ERROR
            when 'fatal', 0
              Logger::FATAL
            else
              raise 'Log level must be one of debug, info, warn, error, or fatal'
          end
        end
        opts.on('-L', '--logfile FILE', 'Log to FILE instead of standard error') { |f| log.reopen(f) }
        opts.on('-m', '--map FILE', 'Map file (must have tag indicating where to insert CSS)') { |m| @map = m }
        #opts.on('-n', '--colour-levels N', 'Number of colour levels to use (more important when used with -b) -- the options available are limited by your chosen palette (-p)') { |n| @palette_size = n }
        opts.on('-N', '--normalise [FACTOR]', 'Normalise your data by FACTOR') do |f|
          die "No normalisation factor supplied, -N requires an argument (try -N population)" unless f and f.strip != ''
          if ['population', 'gdp', 'area'].include? f.downcase.strip
            @normalise = f.downcase.strip.to_sym
          else
            log.fatal "Invalid normalisatoin option: #{f}"
            puts "Don't know how to normalise by #{f}"
            exit
          end
        end
        opts.on('-o', '--output FILE', 'Output to FILE instead of using the same name as the input with an extension of .svg') { |out| @output.output = out }
        opts.on('-pPALETTE', '--palette PALETTE', 'Palette (set of colours) to use (must be one of available options)') do |set|
          unless ColourRange.palettes_array.include? set.to_sym
            log.fatal "Unknown palette #{set}."
            log.fatal "Choose from #{ColourRange.available}"
            exit 1
          end
          log.info "Palette set to #{set}"
          @palette = set.to_sym
        end
        opts.on('-R', '--reverse', 'Reverse palette') { @reverse = true; log.debug "Reversing colours" }
        opts.on('-t', '--title TITLE', 'Set a title for the graph') { |t| @title = t }
        opts.on('-u', '--unit UNIT', 'Set legend unit to UNIT') { |u| @legend_unit = u }
        opts.on('-v', '--verbose', 'Display verbose output') { @verbose = true }
        opts.on('-w', '--warn', "Don't overwrite any output files") { @becareful == true }
        #opts.on('-W', '--world-bank [INDICATOR]', 'Use INDICATOR from the World Bank Development #Indicators as your source') do |i|
        #    @wb_indicator = i || 'NV.IND.TOTL.ZS'
        #    @source = :wb
        #  end
        opts.on('-y', '--year', "Year of data to select for World Bank queries") { |y| @wb_year = y }
      
        begin
          #argv = ['h'] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => error
          # Without this rescue, Ruby would print the stack trace
          # of the error. Instead, we want to show the error message,
          # suggest -h or --help, and exit 1.
       
          $stderr.puts error
          $stderr.puts "(-h or --help will show valid options)"
          exit 1
        end
      end
      @input_data = argv[0] if argv[0]
      basename = @input_data.sub /\.csv$/i, ''
      @output ||= basename + '.svg'
      @normalised_data_log ||= basename + '.html'
      @text_legend_file ||= basename + '.legend'
    end
    
    #log.debug("Started #{$0}")
  end
end