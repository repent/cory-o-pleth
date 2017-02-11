require_relative 'logging'
require_relative 'colour'
require_relative 'country'
require_relative 'options'
require_relative 'colour_range'
require_relative 'scale'
require_relative 'basket'
require_relative 'colorbrewer'
require_relative 'data_catalog'
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

      #d = DataCatalog.new
      #ap d.data('NV.IND.TOTL.ZS')
      #exit

      source = :wb

      data = case source
        when :file
          CSV.read @options.input_data
          # Clean data
          # select! returns nil if no changes were made, so have to use non-destructive version
          data = data.select{|line| line[1] && line[1].strip != ''}.collect do |line|
            country,value=line
            # Convert string (from CSV) into float
            if value then value = value.to_f else next end
            [ country, value ]
          end
        when :wb
          DataCatalog.new.data('NV.IND.TOTL.ZS')
      end



      country_data = CSV.read(@options.country_data) #, { headers: true })
      country_data.shift # ditch header
      countries = Countries.new(country_data)
      css = []
      circles = @options.circles ? "opacity: 1;" : ""

      case @options.colour_rule
        # Sort data points into n baskets, each containing a similar number
        when :basket
          basket = Basket.import(@options.palette, @options.palette_size)
          basket.reverse! if @options.reverse
          # get rid of any junk in later columns
          data = data.collect { |d| d.slice(0,2) }.select { |d| d[1] }
          colour_array = basket * data
          colour_array.each do |c|
            next unless countries.has? c[0]
            css.push ".#{countries.translate(c[0])} { fill: ##{c[1].to_hex}; #{circles} }"
          end

        # Give each data point its own colour based on its position between the largest
        # and smallest value
        when :interpolate
          scale = Scale.import(@options.palette, @options.palette_size)
          scale.reverse! if @options.reverse

          # check data and find upper and lower bounds
          max,min=nil,nil
          
          data.each do |line|
            country,value,junk=line
            # ---Check-country-validates--- (done inside Countries)
            # Nudge upper/lower bounds
            begin
              if value # ignore nils
                value = value.to_f
                max ||= value
                min ||= value
                max = value if value > max
                min = value if value < min
              end
            rescue
              binding.pry
            end
          end
          
          diff = max - min
          if diff == 0
            $stderr.puts "Cannot use linear interpolation if all data points are the same.  Try -b"
            exit 1
          end
          
          data.each do |line|
            country,value=line

            if countries.has?(country) and value # drop nils
              begin
                # Look up the 2-letter iso code for the country
                # Convert the raw number into a colour code
                hex = (((value - min) / diff) * 255).round.to_s(16).rjust(2,'0')
                index = ((value - min) / diff) * 100
                # Output CSS
                colour = scale*index
                css.push ".#{countries.translate(country)} { fill: ##{colour.to_hex}; #{circles} } /* raw value: #{value} */"
              #rescue
                #binding.pry
              end
            end
          end
        else
          log.error "Unknown colour rule #{@options.colour_rule}"
          raise
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
      
      output = File.new(@options.output, 'w')
      
      source.each do |l|
        if l =~ /^INJECT-CSS/i
          css.each do |m|
            output.puts m
          end
        else
          output.puts l
        end
      end
    end
  end
end