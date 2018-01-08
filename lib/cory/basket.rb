# No need to require math if you use the prefix, e.g. Math.sqrt(2)
#require Math

# basket * data_array [name, index] = colour_array [name, hex_colour]

module Cory
  class Basket < ColourRange
  
    def *(data) # data array [ territory, value ]
      @labels = []

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
    def thresholds(data)
      data.sort! { |x,y| x[1] <=> y[1] }
    end
    def roundest(x,y)
      return x if x == y
      x,y=y,x if x>y
      #if (x*y).class == Float or (y-x) == 1
      x,y=x.to_f,y.to_f
      #end
      # x is now definitely smaller

      order = Math.log10(y-x)
      puts "Order: #{order}"
      order = order.to_i
      puts "Order rounded: #{order}"



      a = x.round



      #start = order + 10
      #start.downto(order-1) do |o|
      #  guess = (y * 10**o).to_i.to_f / 10**o
      #  puts "y rounded down at order #{o} is #{guess}"
      #  puts "Which fits!" if guess > x and guess < y
      #end
    end
  end
end

def gaps(x,y)
  a,b=0,0
  -10.upto(10) do |index|
    a,b=x.round(index),y.round(index)
    puts "#{index}: #{a},#{b}"
    break if a != b
  end
  puts "Found: #{index}: #{a},#{b}"
end

def numbers_between(a, b, order=0)
  c, d = a.round(order), b.round(order)
  float_range(c, d, 10**order).select { |n| n > a and n < b }
end

def float_range(a, b, step) # returns an array of floats
  x = a.to_f
  result = []
  while x <= b do
    result.push x
    x += step
  end
  result
end