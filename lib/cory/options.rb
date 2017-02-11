require 'optparse'
require 'ostruct'

module Cory
  class Options
    include Logging
    attr_accessor :verbose, :circles, :input_data, :country_data, :colour_rule, :output, :becareful, :map, :palette, :palette_size, :reverse, :header_row, :logfile, :wb_indicator, :wb_year, :source, :title

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
      
      # Set this true if you don't want to overwrite files without asking
      @becareful = false
      log.level = Logger::DEBUG
      @logfile = 'log/cory.log'
      #log.fatal "Hahahaha"

      # Data options
      @source = :file
      # Is there a header in the CSV statistics file?
      @header_row = false
      @wb_indicator = 'NV.IND.TOTL.ZS'
      @wb_year = :latest
      @title = "World Map"

      # Default file locations
      @input_data = 'stats/data.csv'
      @country_data = 'data/country-codes.csv'
      @output = 'output.svg'
      @map = 'maps/BlankMap-World6-cory.svg'
      #@map = 'maps/BlankMap-World8-cory.svg'
      
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
    
    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: #{$0} [options] output"
        
        opts.on('-b', '--basket', 'Group countries into discrete baskets (default: linear-ish interpolation, see docs)') { @colour_rule = :basket }
        opts.on('-c', '--countries FILE', 'Take country name data from FILE (a CSV file)') { |f| @county_data = f }
        #opts.on('--list-colours', 'List available colour sets') { }
        opts.on('-d', '--dry-run', 'Make no changes, just display what would be done and exit') { @dry = true }
        opts.on('-h', '--help', 'Print this help') { puts opts; exit }
        opts.on('-H', '--header', 'Ignore first line of CSV input') { @header_row = true }
        opts.on('-i', '--input FILE', 'Take choropleth data from FILE (a CSV file)') { |f| @input_data = f }
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
        opts.on('-n', '--colour-levels N', 'Number of colour levels to use (more important when used with -b) -- the options available are limited by your chosen palette (-p)') { |n| @palette_size = n }
        opts.on('-p', '--palette PALETTE', 'Palette (set of colours) to use (must be one of available options)') { |set| @palette = set.to_sym }
        opts.on('-R', '--reverse', 'Reverse palette') { @reverse = true }
        opts.on('-v', '--verbose', 'Display verbose output') { @verbose = true }
        opts.on('-w', '--warn', "Don't overwrite any output files") { @becareful == true }
        opts.on('-W', '--world-bank [INDICATOR]', 'Use INDICATOR from the World Bank Development Indicators as your source') do |i|
            @wb_indicator = i || 'NV.IND.TOTL.ZS'
            @source = :wb
          end
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
      @output = argv[0] if argv[0]
    end
    
    #log.debug("Started #{$0}")
  end
end