class String
  def numeric?
    # http://mentalized.net/journal/2011/04/14/ruby-how-to-check-if-a-string-is-numeric/
    Float(self) != nil rescue false
  end
end