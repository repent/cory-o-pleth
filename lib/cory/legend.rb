module Cory
  class Legend
    include Logging

    def initialize(options, colour_range)
      raise "Can't create legend without basket colours" unless options.colour_rule == :basket

      binding.pry

      # First pass:
      #   Start at 20,20
      #   Boxes are 20x20, vertically 10 apart

      location = { x: 20, y: 20 }
      box_size = { x: 20, y: 20 }
      v_spacing = 10   # vertical gap between lines
      h_spacing = 10   # horizontal gap between boxes and text
      font = 'arial'
      font_size = 14
      border = 5
      legend_width = 200

      offset = 18      # get text to line up with boxes

      @output = %Q(<g id="legend">\n)

      total_height = options.palette_size * ( box_size[:y] + v_spacing ) - v_spacing + 2 * border
      @output += %Q(<rect x="#{location[:x]-border}" y="#{location[:y]-border}" width="#{legend_width}" height="#{total_height}" opacity="0.5" fill="#ff0000"></rect>\n)

      y = location[:y]
      1.upto(options.palette_size) do |basket|
        range_text = "AM blah"

        # coloured rectangle
        @output += %Q(<rect x="#{location[:x]}" y="#{y}" height="#{box_size[:y]}" width="#{box_size[:x]}" fill="\##{colour_range[basket-1].to_hex}"></rect>\n)

        # text
        @output += %Q(<text x="#{location[:x]+box_size[:x]+h_spacing}" y="#{y+offset}" font-size="#{font_size}pt" font-family="#{font}">#{range_text}</text>\n)

        y += box_size[:y] + v_spacing
      end
      @output += "</g>\n"
    end

    def to_s
      @output
    end
  end
end