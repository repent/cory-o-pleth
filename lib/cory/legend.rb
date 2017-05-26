module Cory
  class Legend
    include Logging

    def initialize(options, colour_range)
      raise "Can't create legend without basket colours" unless options.colour_rule == :basket

      output = %Q(<g id="legend">\n)

      y = 210
      1.upto(options.palette_size) do |basket|
        y += 25
        range_text = "blah"

        # coloured rectangle
        output += %Q(<rect x="40" y="#{y}" height="20" width="20" fill="\##{colour_range[basket-1].to_hex}"></rect>\n)

        # text
        output += %Q(<text x="65" y="#{y+10}" font-size="12">#{range_text}</text>\n)
      end
      output += "</g>\n"
    end
  end
end