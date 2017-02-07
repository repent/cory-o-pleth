require_relative 'palettes'

module Cory
  class ColourRange
    include Logging

    # Class methods

    def self.import(name, levels)
      # Create a scale from colorbrewer data
      colourset = PALETTES[name.to_sym] # A colour set has different numbers of divisions the same colour range
      unless colourset
        $stderr.puts "Colorbrewer does not have a set called #{name}."
        exit 1
      end
      colourrange = colourset.select{ |r| r.length == levels }
      if colourrange
        # Convert this info (which could be in different formats) into Colours
        # Colour.new is forgiving
        colourrange = colourrange.first
        return self.new(colourrange.collect{ |c| Colour.new(c) })
      else
        $stderr.puts "Colorbrewer set #{name} exists, but does not have a set of #{levels} colours -- choose from #{cb.map{ |r| r.length }.join(', ')}"
        exit 1
      end
    end

    # Instance methods

    def length
      @points.length
    end
    def [](index)
      @points[index]
    end

    private
    
    def initialize(points) # array of colours
      #binding.pry
      # Need 2+ coordinates for a linear scale but 1 makes sense for a basket, e.g. if we are just
      # highlighting countries that fit a criterion
      raise "Invalid scale #{points}" unless points.class.name === 'Array' and points.length >= 1
      @points=points
    end
  end
end