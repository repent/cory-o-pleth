# basket * data_array [name, index] = colour_array [name, hex_colour]
require_relative 'float'
#require_relative 'legend'
require_relative 'svg'
require 'roundest'


module Cory
  class Basket
    include Comparable
    include Enumerable
    attr_accessor :countries, :colour
    def initialize(countries, colour, options)
      #data = data_slice.collect { |d| d[1] }
      @countries = countries
      @colour = colour
      @options = options
      #@upper = .max
      #@lower = data.min
    end
    # Comparable requirement
    def <=>(other); self.max <=> other.max; end
    # Enumerable requirement
    def each; @countries.each { |c| yield c }; end
    # Other
    def to_s; "min: #{min.simple}, max: #{max.simple}, colour: #{@colour}, contents: #{@countries.length}"; end
    def max; @countries.max.data_point; end
    def min; @countries.min.data_point; end
    def to_css
      css = []
      @countries.each do |country|
        css << ".#{country.alpha_2.downcase} { fill: ##{@colour.to_hex}; #{@options.circles_css} }"
      end
      css
    end
    def data_summary(html)
      @countries.each do |country|
        html.puts country.data_summary #[ %Q["country.to_s"] , country.data_point ]
      end
    end
  end

  class Baskets < ColourRange
    include Enumerable
    # @points -- array of Colours, one representing each basket
    # @baskets -- array of Basket objects (which contain countries)

    # Methods
    #
    #
    # private
    #
    # basket_sizes: sizes of each basket, e.g. [ 3, 4, 3 ]

    # Enumerable requirement
    def each
      @baskets.each { |b| yield b }
    end

    # Distribute a set of countries among a set of baskets
    def fill(countries) # Countries object
      # Where is information coming from?
      #   @points tells us the number of baskets
      #   countries contains statistical data

      # Clean up countries
      countries.compact! # ditch countries without data (they are only shells to parse incoming data)
      countries.reject! { |c| !c.data_point } # remove countries that don't have a data point
      countries.sort! # according to the countries' data points (low to high)
      countries.reverse! # I HAVE NO IDEA WHY
      
      # Create baskets
      @baskets = []
      # Put countries into baskets
      # Array#into_slices is not standard Ruby
      countries.into_slices(basket_sizes(countries.length)).each_with_index do |slice, index|
        @baskets.push Basket.new slice, @points[index], @options
      end
    end

    # An array with one line of css in each line
    def to_css
      css = []
      @baskets.each do |basket|
        css << basket.to_css
      end
      css
    end

    def data_summary
      # TODO: Ratoinalise the format of to_csv across objects (who should know about the actual file?)
      n = 0
      log.info "Writing data to #{@options.normalised_data_log}"
      File.open(@options.normalised_data_log, 'wt') do |html|
        html.puts "<!DOCTYPE HTML>"
        html.puts %Q(<html><head><link rel="stylesheet" type="text/css" href="class.css" />)
        html.puts '<meta charset="UTF-8"></head>'
        html.puts "<h1>Data summary</h1>"
        html.puts "<table>"
        html.puts "<tr><th>Country</th><th>Raw data</th><th>Normaliser</th><th>Mapped result</th></tr>"
        @baskets.each do |basket|
          html.puts %Q(<tr><th colspan=4 bgcolor="##{basket.colour.to_hex}">Basket #{n+=1}: #{basket}</th></tr>)
          basket.data_summary(html)
        end
      end
    end

    def print_legend
      str = ''
      @baskets.each do |b|
        str << "#{f(b.min)} --- #{f(b.max)}   #{b.colour}   [#{b.countries.length} countries]" << "\n"
      end
      str
    end

    def svg_legend(output)
      ############################################################################
      # Safe location for legend in Blank World Map 6:
      # x: 300 to 620 (width 320)
      # y: 700 to 1250 (height 550)
      ############################################################################
      x_side = 50
      y_side = 30
      spacing = 10
      position = 0
      text_offset = 10 + y_side / 2
      sup, sub = -10, 10
      x_pos = 100 # 300
      y_pos = 700

      x_unit_offset = 80
      y_unit_offset = 30

      legend = Builder::XmlMarkup.new( target: output, indent: 2 )
      #legend.link rel: 'stylesheet', href: 'css/legend.css', type: 'text/css' 
      #legend.rect x: 300, y: 700, width: 320, height: 550, fill: 'black'
      position += y_pos
      legend.g id: 'legend' do
        @baskets.each do |basket|
          legend.rect x: x_pos, y: position, height: y_side, width: x_side, fill: basket.colour, class: 'swatch'
          legend.text x: x_pos + x_side + spacing, y: position + text_offset, class: 'legend_text' do
            legend.tspan basket.min.index
            legend.tspan basket.min.exponent, dy: sup
            legend.tspan " — #{basket.max.index}", dy: sub
            legend.tspan basket.max.exponent, dy: sup
          end
          position += y_side + spacing
        end
        legend.rect x: x_pos, y: position, height: y_side, width: x_side, fill: @options.no_data_colour, class: 'swatch'
        legend.text x: x_pos + x_side + spacing, y: position + text_offset, class: 'legend_text' do
          legend.tspan 'no data'
        end
        position += y_side + spacing
        if @options.legend_unit
          legend.text x: x_pos + x_unit_offset, y: position + y_unit_offset, class: 'legend_unit' do
            legend.tspan @options.legend_unit
          end
        end
      end
    end

    #def legend_line(colour, text)
    #def legend_box(position, colour)

    #end

    def svg_legend_test
      side = 50
      spacing = 10
      position = 0
      text_offset = 30


      File.open('svgtest.svg', 'wt') do |svg_legend|
        legend = Builder::XmlMarkup.new( target: svg_legend, indent: 2 )
        legend.instruct! :xml, encoding: 'UTF-8', standalone: 'no'
        #legend << %Q(<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"\n)
        #legend.html do
          #legend.meta charset: 'UTF-8'
          #legend.body do
            #legend.style type: 'text/css', href: 'css/legend.css'
            legend.svg version: '1.1', height: '1000', width: '1000', xmlns: "http://www.w3.org/2000/svg" do
              legend.link rel: 'stylesheet', href: 'css/legend.css', type: 'text/css' 
              position = 0
              side, spacing = 50, 10
              sup, sub = -10, 10
              @baskets.each do |basket|
                legend.rect x: 0, y: position, height: side, width: side, fill: basket.colour, class: 'swatch'
                legend.text x: side + spacing, y: position + text_offset, class: 'legend_text' do
                  legend.tspan basket.min.index
                  legend.tspan basket.min.exponent, dy: sup
                  legend.tspan " — #{basket.max.index}", dy: sub
                  legend.tspan basket.max.exponent, dy: sup
                end
                position += side + spacing
              end   
            end
          #end
        #end
      end
      File.readlines('svgtest.html').each { |l| puts l }
    end

    #def text_legend # dump legend info
    #
    #end

    private

    def f(x) # print a float
      sprintf("%.2e", x).gsub("e", " e")
    end
    def colour_of(country)
      raise "Baskets uninitialized" unless @baskets
      @baskets.each do |b|
        if b.has? country
          return b.colour
        end
      end
      raise "Unknown colour"
    end

    def n_baskets # should normally be odd
      log.warn "Number of baskets shouldn't be even (got #{@colour_array.length})" if @points.length % 2 == 0
      @points.length
    end
    # Return sizes of each basket when given a number of baskets and a number of countries to put in them
    # e.g. 10 countries in 3 baskets => [ 3, 4, 3 ]
    def basket_sizes(n_countries)
      result = Array.new(n_baskets, n_countries / n_baskets) # will round down
      remainder = n_countries % n_baskets
      start_point = (n_baskets - remainder) / 2
      start_point.upto(start_point+remainder-1) { |n| result[n] += 1 }
      log.debug "Basket sizes: #{result}"
      result
    end
    #def basket_ranges(n_data_points)
    #  ranges = []
    #  lower = 0
    #  basket_sizes(n_data_points).each do |size|
    #    upper = size + lower
    #    ranges.push lower...upper # EXCLUSIVE range
    #    lower = upper # upper is EXCLUDED from its range, so should be the SAME as lower (not one above)
    #  end
    #  return ranges
    #end
  end
end
