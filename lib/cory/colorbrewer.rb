# This product includes color specifications and designs developed by Cynthia Brewer (http://colorbrewer.org/).
# JavaScript specs as packaged in the D3 library (d3js.org). Please see license at http://colorbrewer.org/export/LICENSE.txt

module Cory
  class Colorbrewer
    def initialize
    end
    def [](index)
      @colorbrewer[index]
    end
    def to_h
      @colorbrewer
    end
  end
end