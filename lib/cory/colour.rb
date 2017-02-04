module Cory
  class Colour
    # internal: @a = [4, 104, 212] = [r,g,b]
    def initialize(parms=nil, *extra)
      if extra[0]
        parms = [parms]+extra
      end
      case parms
      when String
        s = parms.gsub '#', ''
        raise "Bad colour #{parms}" unless s.length == 6
        h_arr=s[0,2],s[2,2],s[4,2]
        @a = h_arr.collect{ |x| to_d(x) }
      when Array
        raise "Bad colour #{parms}" unless parms.count == 3
        @a = parms.collect {|i| i.to_f.round }
      when nil
        @a = [0,0,0]
      else
        raise "Unknown colour type #{parms.to_s}"
      end
    end
    def []=(index, new_colour)
      @a[index]=new_colour
    end
    def [](index)
      @a[index]
    end
    def to_hex
      #binding.pry
      @a.collect{ |x| to_h(x)}.join
    end
    def r; @a[0]; end
    def g; @a[1]; end
    def b; @a[2]; end
    def +(o)
      Colour.new(r+o.r, g+o.g, b+o.b)
    end
    def -(o)
      Colour.new(r-o.r, g-o.g, b-o.b)
    end
  
    private
    def to_h(n)
      # in case n is a float
      n.round.to_s(16).rjust(2, '0')
    end
    def to_d(s)
      s.to_i(16)
    end
  end
end
