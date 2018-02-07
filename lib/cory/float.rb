class Float
  def simple
    sprintf("%.2e", self).gsub("e", " e")
  end
end