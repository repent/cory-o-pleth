#module Cory
#  class Datapoint
#    include Logging
#
#    def initialize(country, data=nil)
#      @country=country
#      @data=data
#    end
#
#    # Class methods
#
#    def self.create_from_csv(arr)
#      country = arr[0]
#      data = arr[1]
#      log.debug "Additional data found when creating datapoint from csv [#{arr.slice[2,10].join(', ')}]" if arr[2]
#      data = data.to_f if data.class == String
#      self.new(country, data)
#    end
#  end
#end