class String
  def to_f_or_nil
    if self.strip == ''
      nil
    else
      self.to_f
    end
  end
end