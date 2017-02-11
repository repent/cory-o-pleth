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
        $stderr.puts "Try: #{available}" #.scan(/\S.{0,70\S(?=\s|$)|\S+/)
        exit 1
      end
      colourrange = colourset.select{ |r| r.length == levels.to_i }
      if colourrange and colourrange.length>0
        # Convert this info (which could be in different formats) into Colours
        # Colour.new is forgiving
        colourrange = colourrange.first
      else
        $stderr.puts "Colorbrewer set #{name} exists, but does not have a set of #{levels} colours -- choose from #{colourset.map{ |r| r.length }.join(', ')}"
        exit 1
      end
      self.new(colourrange)
    end

    def self.available
      PALETTES.to_a.collect { |a| a[0].to_s }.join(', ')
    end

    # Instance methods

    def length
      @points.length
    end
    def [](index)
      @points[index]
    end
    def reverse!
      @points.reverse!
      self # otherwise this would return an array
    end

    private
    
    def initialize(points) # array of Colours or strings representing hex colours
      #binding.pry
      # Need 2+ coordinates for a linear scale but 1 makes sense for a basket, e.g. if we are just
      # highlighting countries that fit a criterion
      raise "Invalid scale #{points}" unless points.class.name === 'Array' and points.length >= 1
      @points = points.collect { |p| Colour.new(p) }
      self
    end
  end
end