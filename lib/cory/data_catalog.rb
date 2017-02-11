require 'httparty'

module Cory
  class DataCatalog
    include HTTParty
    # http://api.worldbank.org/incomeLevels/LIC/countries
    base_uri 'api.worldbank.org'

    def data(id) # [ country, value ]
      query(id)['data']['data'].collect { |h| [ h['country']['__content__'], to_i_or_nil(h['value']) ] }
    end

    def query(id='SP.POP.TOTL', options={date: 2015})
      #options.merge!({page: 1, per_page: 500})
      self.class.get("/countries/all/indicators/#{id}?date=#{2015}&per_page=#{500}", options)
    end

    def to_i_or_nil(str)
      str ? str.to_i : nil
    end
    def to_f_or_nil(str)
      str ? str.to_f : nil
    end
    #def initialize(service, page)
    #  @options = { query: { site: service, page: page } }
    #end
  #
    #def questions
    #  self.class.get("/2.2/questions", @options)
    #end
  #
    #def users
    #  self.class.get("/2.2/users", @options)
    #end

  end
end

# Request Format
# 
# Requests support the following parameters:
# 
# date – date-range by year, month or quarter that scopes the result-set. A range is indicated using the colon separator
# > http://api.worldbank.org/countries/all/indicators/SP.POP.TOTL?date=2000:2001
# > http://api.worldbank.org/countries/chn;bra/indicators/DPANUSIFS?date=2009M01:2010M08
# > http://api.worldbank.org/countries/chn;bra/indicators/DPANUSIFS?date=2009Q1:2010Q3
# 
# additionally supports, year to date values (YTD: ). Useful for querying high frequency data
# > http://api.worldbank.org/countries/chn;bra/indicators/DPANUSIFS?date=YTD:2010
# 
# format – output format. API supports three formats: XML, JSON and JSONP
# > http://api.worldbank.org/countries/all/indicators/SP.POP.TOTL?format=xml
# > http://api.worldbank.org/countries/all/indicators/SP.POP.TOTL?format=json
# > http://api.worldbank.org/countries/all/indicators/SP.POP.TOTL?format=jsonP&prefix=Getdata
# 
# Note: For JsonP format, 'prefix' parameter needs to be specified.
# 
# page – utility parameter for paging through a large result-set. Indicates the page number requested from the recordset.
# > http://api.worldbank.org/countries/all/indicators/SP.POP.TOTL?page=2
# 
# per_page – number of results per page, for pagination of the result-set. Default setting is 50
# > http://api.worldbank.org/countries/all/indicators/SP.POP.TOTL?per_page=25
# 
# MRV - fetches most recent values based on the number specified.
# > http://api.worldbank.org/countries/chn;bra/indicators/DPANUSIFS?MRV=5
# > http://api.worldbank.org/countries/chn;bra/indicators/DPANUSIFS?date=2008M05:2009M10&MRV=5
# 
# Gapfill - (Y/N) Works with MRV. Fills values, if not available, by back tracking to the next available period (max number of periods back tracked will be limited by MRV number)
# > http://api.worldbank.org/countries/chn;bra/indicators/DPANUSIFS?MRV=5&Gapfill=Y
# 
# Frequency - for fetching quarterly (Q), monthly(M) or yearly (Y) values. Currently works along with MRV. Useful for querying high frequency data.
# > http://api.worldbank.org/en/countries/ind;chn/indicators/DPANUSSPF?MRV=7&frequency=M
# > http://api.worldbank.org/en/countries/ind;chn/indicators/DPANUSSPF?date=2000:2006&MRV=5&frequency=Q