module Cory
  class Scale
    def initialize(points) # array of colours
      # Need 2+ coordinates for a linear scale but 1 makes sense for a basket, e.g. if we are just
      # highlighting countries that fit a criterion
      raise "Invalid scale #{points}" unless points.class.name === 'Array' and points.length >= 1
      @points=points
    end
    #def *(index)
    ##  # linear interpolation
    ##  # find two closest points
    ##  # interpolate
    ##  interpolate(index)
    #end
    def *(i)
      x_n = closest(i)
      x = x_n.collect{ |j| j*spacing }
      y = [ @points[x_n[0]],@points[x_n[1]] ]
      result = Colour.new
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
    def spacing
      100.0 / (@points.length-1)
    end
    def length
      @points.length
    end
    def [](index)
      @points[index]
    end
    def closest(index)
      ##puts "spacing: #{spacing}"
      #under,over=100,0
      #0.upto(@points.length-1) do |n|
      #  x=n*spacing
      #  #puts "under: #{under}; over: #{over}; index: #{index}; x: #{x}"
      #  under = x if x < index
      #  over = (100 - x) if (100 - x) > index
      #end
      #puts "#{[under,over]}.to_s"
      #puts under, over, index
      under,over=@points.length,0
      0.upto(@points.length-1) do |n|
        under = n if n <= (index / spacing)
        over = (@points.length - n) if (@points.length - n) >= (index / spacing)
      end
      [under,over]
    end
  end
end