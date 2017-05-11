module Cory
  class Scale < ColourRange
    # Multiply this Scale by a data array to return an array of countries and colours
    # Currently this is only being multiplied by a float
    def *(data)
      begin
        raise "Scale.* requires a populated array (got #{data})" unless data.class == Array and !data.empty?
      rescue => e
        ap e.error
        ap e.backtrace
      end

      # Find upper and lower bounds, and the distance between them
      min,max = limits(data)
      diff = max - min
      if diff == 0
        $stderr.puts "Cannot use linear interpolation if all data points are the same.  Try -b"
        exit 1
      end

      result = []
      data.each do |line|
        country,value=line
        # hex = (((value - min) / diff) * 255).round.to_s(16).rjust(2,'0')
        index = ((value - min) / diff) * 100 # diff checked for zero above
        result.push([ country, index_to_colour(index) ])
      end

      result # Array, each line [ 'country_name', Colour ]
    end

    private

    def limits(data)
      min=max=nil
      data.each do |line|
        value=line[1]
        # Nudge upper/lower bounds
        max ||= value
        min ||= value
        max = value if value > max
        min = value if value < min
      end
      [min,max]
    end

    def index_to_colour(i)
      x_n = closest(i)
      x = x_n.collect{ |j| j*spacing }
      y = [ @points[x_n[0]],@points[x_n[1]] ]
      result = Colour.new('#000000')
      # edge case that causes problems: bang on a point in the scale (so x[1]-x[0] is divide-by-zero)
      return @points[x_n[0]] if x_n[0] == x_n[1]
      # for each element of a colour (r,g,b)
      [0,1,2].each do |colour|
        proportion = (i - x[0]) / (x[1] - x[0])
        result[colour] = y[0][colour] + proportion * (y[1][colour] - y[0][colour])
        binding.pry if result[colour].nan?
      end
      result # Colour
    end

    public

    # Distance between adjacent points, as a percentage of the overall scale
    def spacing
      100.0 / (@points.length-1)
    end
    # Returns the points in the scale immediately above and below a given index
    def closest(index)
      under,over=@points.length,0
      0.upto(@points.length-1) do |n|
        under = n if n <= (index / spacing)
        over = (@points.length - n) if (@points.length - n) >= (index / spacing)
      end
      [under,over]
    end
  end
end
