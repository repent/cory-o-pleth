require 'builder'

module Cory
  class Svg
    def initialize(filename)
      @filename = filename
    end
    def add_basket(basket)
    end
    def write
      svg = Builder::XmlMarkup.new(indent: 2)
      # <?xml version="1.0" encoding="UTF-8"?>
      svg.instruct! :xml, encoding: 'UTF-8'
      
      File.open(@filename, 'wt') do |f|
        f.puts "<html>"
        f.puts "<body>"
      end
    end
    #def open(filename, mode, &block)
    #  File.open(filename, mode, &block)
    #end
  end
end