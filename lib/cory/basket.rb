# basket * data_array [name, index] = colour_array [name, hex_colour]

module Cory
  class Basket
    include Comparable
    attr_accessor :countries, :colour, :upper, :lower
    def initialize(data_slice, colour)
      data = data_slice.collect { |d| d[1] }
      @countries = data_slice.collect { |d| d[0] }
      @colour = colour
      @upper = data.max
      @lower = data.min
    end
    def has?(country)
      @countries.each do |c|
        return true if c == country
      end
      false
    end
    def <=>(other)
      self.upper <=> other.upper
    end
  end

  class Baskets < ColourRange
    # @points -- array of Colours, one representing each basket
    #  -- boundaries of each basket
    #  -- number of countries in each basket

    #def initialize(colour_array)
    #  @colour_array = colour_array
    #end
    def *(data) # return array, each row: country_name, colour (and record baskets!)
      # Sort countries into data order
      data.sort! { |x,y| x[1] <=> y[1] }
      # @basket: array of Basket objects
      # Iterate over data, placing each country into a basket
      points = @points.dup
      @baskets = []
      basket_ranges(data.length).each do |range|
        @baskets.push Basket.new data.slice(range), points.pop
      end
      result = data.collect { |d| [ d[0], colour_of(d[0]) ] }
    end

    def %(data)
      data.sort! { |x,y| x[1] <=> y[1] }
      result = []
      colour_index=0
      j,k=0,0
      basket_sizes_array = basket_sizes(data.length)
      data.each_with_index do |d,i|
        result[i] = [ d[0], Colour.new(@points[colour_index]) ]
        j += 1
        if j == basket_sizes_array[k]
          colour_index += 1
          j=0
          k+=1
        end
      end
      result # Array, each line [ 'country_name', Colour ]
    end

    def print_legend
      @baskets.each do |b|
        puts "#{b.lower}-#{b.upper}   #{b.colour}   [#{b.countries.length} countries]"
      end
    end

    def text_legend # dump legend info

    end

    private

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
    def basket_sizes(n_data_points)
      result = Array.new(n_baskets, n_data_points / n_baskets) # will round down
      remainder = n_data_points % n_baskets
      start_point = (n_baskets - remainder) / 2
      start_point.upto(start_point+remainder-1) { |n| result[n] += 1 }
      log.debug "Basket sizes:"
      log.debug result.to_s
      result
    end
    def basket_ranges(n_data_points)
      ranges = []
      lower = 0
      basket_sizes(n_data_points).each do |size|
        upper = size + lower
        ranges.push lower...upper # EXCLUSIVE range
        lower = upper # upper is EXCLUDED from its range, so should be the SAME as lower (not one above)
      end
      return ranges
    end
  end
end
