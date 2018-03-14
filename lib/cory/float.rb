class Float
  def simple
    sprintf("%.2e", self).gsub("e", " e")
  end
  def two_part
    sprintf("%.2e", self).split 'e'
  end
  def exponent
    two_part[1].sub '-0', '-'
  end
  def index
    "#{two_part[0]} ×10"
  end 
  def to_svg(use_unicode=true)
    #%Q(#{two_part[0]} x10<tspan baseline-shift="super">#{two_part[1]}</tspan>)
    if use_unicode
      %Q(#{two_part[0]} ×10<sup>#{two_part[1]}</sup>)
    else
      %Q(#{two_part[0]} x10<sup>#{two_part[1]}</sup>)
    end
  end
  def factor
  end
  # TODO: COMPLETE
  def to_wikipedia(format=nil)
    case format
    when :crap
      a,b = two_part
      b = b.to_i
      if b >= -2 and b <= 4
        # Print in a sensible (non SF) way
        %Q(#{a} × 10<sup>#{b}</sup>)
      else
        %Q(#{a} × 10<sup>#{b}</sup>)
      end
    else
      %Q(#{two_part[0]} × 10<sup>#{two_part[1]}</sup>)
    end
  end
end