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
  def to_svg
    #%Q(#{two_part[0]} x10<tspan baseline-shift="super">#{two_part[1]}</tspan>)
    %Q(#{two_part[0]} x10<sup>#{two_part[1]}</sup>)
  end
  def factor
  end
end