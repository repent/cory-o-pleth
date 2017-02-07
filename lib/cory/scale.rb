module Cory
  class Scale < ColourRange
    # Multiply this Scale by a data array to return an array of countries and colours
    def *(i)
      x_n = closest(i)
      x = x_n.collect{ |j| j*spacing }
      y = [ @points[x_n[0]],@points[x_n[1]] ]
      result = Colour.new('#000000')
      # edge case that causes problems: bang on a point in the scale (so x[1]-x[0] is divide-by-zero)
      return @points[x_n[0]] if x_n[0] == x_n[1]
      # for each element of a colour (r,g,b)
      [0,1,2].each do |colour|
        proportion = (i - x[0]) / (x[1] - x[0])
        #binding.pry
        result[colour] = y[0][colour] + proportion * (y[1][colour] - y[0][colour])
        binding.pry if result[colour].nan?
      end
      result
    end
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