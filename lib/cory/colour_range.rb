require_relative 'palettes'

module Cory
  class ColourRange
    include Logging

    # Class methods

    def self.import(options)
      name, levels = options.palette, options.palette_size
      colourset = ColourRange.get_colourset(name)
      # A colour range is the slice of a colour set for a given number of shades
      colourrange = colourset.select{ |r| r.length == levels.to_i }
      if colourrange and colourrange.length>0
        # Convert this info (which could be in different formats) into Colours
        # Colour.new is forgiving
        colourrange = colourrange.first
      else
        log.fatal "Colorbrewer set #{name} exists, but does not have a set of #{levels} colours -- choose from #{colourset.map{ |r| r.length }.join(', ')}"
        exit 1
      end
      self.new(colourrange, options)
    end

    def self.available
      PALETTES.to_a.collect { |a| a[0].to_s }.join(', ')
    end

    def self.palettes_array
      PALETTES.keys
    end

    def self.single_colour(options) # Return just the strongest colour for a binary map
      ColourRange.import(options).strongest(options.palette)
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
    def each; @points.each { |p| yield p }; end
    def strongest(palette)
      colourset = ColourRange.get_colourset(palette)
      # Return the colour from a set of one if it exists (which has been hand selected)
      single = colourset.select { |r| r.length == 1 }
      return single.first unless single.empty?
      # Otherwise, return the darkest (last) of the 3-colour set (worked for Blues)
      Colour.new colourset.select { |r| r.length == 3 }.first.last
    end

    private
    
    def self.get_colourset(name)
      # Create a set of colours from colorbrewer data
      colourset = PALETTES[name.to_sym] # A colour set has different numbers of divisions the same colour range
      unless colourset
        log.fatal "Colorbrewer does not have a set called #{name}."
        log.info "Try: #{available}" #.scan(/\S.{0,70\S(?=\s|$)|\S+/)
        exit 1
      end
      colourset
    end
    def initialize(points, options) # array of Colours or strings representing hex colours
      @options = options
      # Need 2+ coordinates for a linear scale but 1 makes sense for a basket, e.g. if we are just
      # highlighting countries that fit a criterion
      raise "Invalid scale #{points}" unless points.class.name === 'Array' and points.length >= 1
      @points = points.collect { |p| Colour.new(p) }
      self
    end
  end
end