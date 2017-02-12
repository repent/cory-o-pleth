require 'httparty'

module Cory
  class Indicator
    attr_accessor :name, :id
    def initialize(raw)
      @name, @id = raw['name'], raw['id']
    end
    def dump
      puts "Name: #{@name}"
      puts "ID:   #{@id}"
    end
  end


  class Indicators
    include HTTParty
    include Logging
    base_uri 'api.worldbank.org'

    def initialize
      log.info "Requesting list of indicators from World Bank..."
      r = page('/indicators')
      @i = r.collect {|i| Indicator.new(i) }
    end
    def dump
      @i.each {|i| i.dump}
    end
    def search(regex)
      matches = @i.select {|i| regex =~ i.name }
      matches.each {|m| puts m.id }
      return false
    end

    private
    def page(request, per_page=1000)
      log.debug "Sending paged request to WB (#{request}, #{per_page} requests per page)..."
      i = []
      r = raw("#{request}?per_page=#{per_page}")
      total, pages = r['total'].to_i,r['pages'].to_i
      log.info "A total of #{total} indicators avaible"
      1.upto(pages) do |p|
        log.debug "Page #{p}"
        i += raw_indicators("/#{request}?per_page=#{per_page}&page=#{p}")
      end
      i
    end
    def raw_indicators(q)
      raw(q)['indicator']
    end
    def raw(q)
      r = self.class.get(q)
      raise "Unexpected response: #{r}" unless r['indicators'] and r['indicators']['indicator']
      r['indicators'] #['indicator']
    end   
  end
end

# => {"indicators"=>
#   {"indicator"=>
#     [{"name"=>"Divisia Decomposition Analysis - Energy Intensity component Index",
#       "source"=>{"__content__"=>"Sustainable Energy for All", "id"=>"35"},
#       "sourceNote"=>nil,
#       "sourceOrganization"=>nil,
#       "topics"=>nil,
#       "id"=>"18.1_DECOMP.EFFICIENCY.IND"},
#      {"name"=>"Energy intensity of residential sector (GJ/household)",
#       "source"=>{"__content__"=>"Sustainable Energy for All", "id"=>"35"},
#       "sourceNote"=>nil,
#       "sourceOrganization"=>nil,
#       "topics"=>nil,
#       "id"=>"17.1_HOUSEHOLD.ENERG.INTENSITY"},
