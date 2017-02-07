# basket * data_array [name, index] = colour_array [name, hex_colour]

module Cory
  class Basket < ColourRange
  
    #def initialize(colour_array)
    #  @colour_array = colour_array
    #end
    def *(data)
      data.sort! { |x,y| x[1] <=> y[1] }
      result = []
      colour_index=0
      j,k=0,0
      basket_sizes_array = basket_sizes(data.length)
      data.each_with_index do |d,i|
        result[i] = [ d[0], @points[colour_index] ]
        j += 1
        if j == basket_sizes_array[k]
          colour_index += 1
          j=0
          k+=1
        end
      end
      result
    end

    private

    def n_baskets # should normally be odd
      log.warn "Number of baskets shouldn't be even (got #{@colour_array.length})" if @points.length % 2 == 0
      @points.length
    end
    def basket_sizes(n_data_points)
      result = Array.new(n_baskets, n_data_points / n_baskets) # will round down
      remainder = n_data_points % n_baskets
      start_point = (n_baskets - remainder) / 2
      start_point.upto(start_point+remainder-1) { |n| result[n] += 1 }
      log.debug result.to_s
      result
    end
  end
end
