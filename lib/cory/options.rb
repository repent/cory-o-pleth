require 'optparse'
require 'ostruct'

module Cory
  class Options < OpenStruct
    include Logging
    attr_accessor :verbose, :circles, :input_data, :country_data, :colour_rule, :output, :becareful, :colour_set, :map

    def initialize(argv)
      @verbose = false
      # dry = false,
      # Display options
      @circles = true
      @input_data = 'data.csv'
      @country_data = 'country-codes.csv'
      @colour_rule = :interpolate # c.f. basket
      @output = 'output.svg'
      @becareful = false
      @colour_set = :traffic_lights
      @map = 'BlankMap-World8-cory.svg'
      
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
        
        opts.on('-b', '--basket', 'Group countries into discrete baskets (default: linear-ish interpolation, see docs)') { raise "Not implemented"; @colour_rule = :basket }
        opts.on('-cFILE', '--countries=FILE', 'Take country name data from FILE (a CSV file)') { |f| @county_data = f }
        opts.on('-CSET', '--colour=SET', 'Colour set to use (must be one of available options)') { |set| @colour_set = set.to_sym }
        #opts.on('--list-colours', 'List available colour sets') { }
        opts.on('-d', '--dry-run', 'Make no changes, just display what would be done and exit') { @dry = true }
        opts.on('-h', '--help', 'Print this help') { puts opts; exit }
        opts.on('-iFILE', '--input=FILE', 'Take choropleth data from FILE (a CSV file)') { |f| @input_data = f }
        opts.on('-lLEVEL', '--log=LEVEL', 'Set log level (from debug, info, warn, error, fatal)') do |level|
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
        opts.on('-LFILE', '--logfile=FILE', 'Log to FILE instead of standard error') { |f| log.reopen(f) }
        opts.on('-mFILE', '--map=FILE', 'Map file (must have tag indicating where to insert CSS)') { |m| @map = m }
        opts.on('-v', '--verbose', 'Display verbose output') { @verbose = true }
        opts.on('-w', '--warn', "Don't overwrite any output files") { @becareful == true }
      
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