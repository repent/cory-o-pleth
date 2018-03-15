require_relative 'palettes'

module Cory
  class ColourRange
    include Logging

    # Class methods

    def self.import(options)
      name, levels = options.palette, options.palette_size
      # Create a set of colours from colorbrewer data
      colourset = PALETTES[name.to_sym] # A colour set has different numbers of divisions the same colour range
      unless colourset
        log.fatal "Colorbrewer does not have a set called #{name}."
        log.info "Try: #{available}" #.scan(/\S.{0,70\S(?=\s|$)|\S+/)
        exit 1
      end
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

    private
    
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