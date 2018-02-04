# basket * data_array [name, index] = colour_array [name, hex_colour]

module Cory
  class Basket
    include Comparable
    include Enumerable
    attr_accessor :countries, :colour
    def initialize(countries, colour, options)
      #data = data_slice.collect { |d| d[1] }
      @countries = countries
      @colour = colour
      @options = options
      #@upper = .max
      #@lower = data.min
    end
    # Comparable requirement
    def <=>(other); self.upper <=> other.upper; end
    # Enumerable requirement
    def each; @countries.each { |c| yield c }; end
    # Other
    def to_s; "min: #{min}, max: #{max}, colour: #{@colour}, contents: #{@countries.length}"; end
    def max; @countries.max.data_point; end
    def min; @countries.min.data_point; end
    def to_css
      css = []
      @countries.each do |country|
        css << ".#{country.alpha_2} { fill: ##{@colour.to_hex}; #{@options.circles_css} }"
      end
      css
    end
    def to_csv(csv)
      @countries.each do |country|
        csv << country.to_csv #[ %Q["country.to_s"] , country.data_point ]
      end
    end
  end

  class Baskets < ColourRange
    include Enumerable
    # @points -- array of Colours, one representing each basket
    # @baskets -- array of Basket objects (which contain countries)

    # Methods
    #
    #
    # private
    #
    # basket_sizes: sizes of each basket, e.g. [ 3, 4, 3 ]

    # Enumerable requirement
    def each
      @baskets.each { |b| yield b }
    end

    # Distribute a set of countries among a set of baskets
    def fill(countries) # Countries object
      # Where is information coming from?
      #   @points tells us the number of baskets
      #   countries contains statistical data

      # Clean up countries
      countries.compact! # ditch countries without data (they are only shells to parse incoming data)
      countries.sort! # according to the countries' data points
      
      # Create baskets
      @baskets = []
      # Put countries into baskets
      # Array#into_slices is not standard Ruby
      countries.into_slices(basket_sizes(countries.length)).each_with_index do |slice, index|
        @baskets.push Basket.new slice, @points[index], @options
      end
    end

    # An array with one line of css in each line
    def to_css
      css = []
      @baskets.each do |basket|
        css << basket.to_css
      end
      css
    end

    def to_csv
      # TODO: Ratoinalise the format of to_csv across objects (who should know about the actual file?)
      n = 0
      CSV.open(@options.normalised_data_log, 'wb') do |csv|
        @baskets.each do |basket|
          csv << [ "Basket #{n+=1}: #{basket}" ]
          basket.to_csv(csv)
        end
      end
    end

    def print_legend
      str = ''
      @baskets.each do |b|
        str << "#{f(b.min)} --- #{f(b.max)}   #{b.colour}   [#{b.countries.length} countries]" << "\n"
      end
      str
    end

    #def text_legend # dump legend info
    #
    #end

    private

    def f(x) # print a float
      sprintf("%.2e", x).gsub("e", " e")
    end
    def colour_of(country)
      raise "Baskets uninitialized" unless @baskets
      @baskets.each do |b|
        if b.has? country
          return b.colour
        end
      end
      raise "Unknown colour"
    end

    def n_baskets # should normally be odd
      log.warn "Number of baskets shouldn't be even (got #{@colour_array.length})" if @points.length % 2 == 0
      @points.length
    end
    # Return sizes of each basket when given a number of baskets and a number of countries to put in them
    # e.g. 10 countries in 3 baskets => [ 3, 4, 3 ]
    def basket_sizes(n_countries)
      result = Array.new(n_baskets, n_countries / n_baskets) # will round down
      remainder = n_countries % n_baskets
      start_point = (n_baskets - remainder) / 2
      start_point.upto(start_point+remainder-1) { |n| result[n] += 1 }
      log.debug "Basket sizes: #{result}"
      result
    end
    #def basket_ranges(n_data_points)
    #  ranges = []
    #  lower = 0
    #  basket_sizes(n_data_points).each do |size|
    #    upper = size + lower
    #    ranges.push lower...upper # EXCLUSIVE range
    #    lower = upper # upper is EXCLUDED from its range, so should be the SAME as lower (not one above)
    #  end
    #  return ranges
    #end
  end
end
