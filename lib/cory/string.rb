class String
  def numeric?
    # http://mentalized.net/journal/2011/04/14/ruby-how-to-check-if-a-string-is-numeric/
    # Fails on '1,200'
    Float(self.gsub(',','')) != nil rescue false
  end
end