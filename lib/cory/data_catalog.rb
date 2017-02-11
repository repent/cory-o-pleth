require 'httparty'

module Cory
  class DataCatalog
    include HTTParty
    OLDEST_YEAR=2012 # if no data exists from this date or newer, fail
    MINIMUM_NUMBER_OF_VALUES=5 # fail unless at least this number of countries has data

    # http://api.worldbank.org/incomeLevels/LIC/countries
    base_uri 'api.worldbank.org'

    def initialize(id,year)
      @id = id
      if year == :latest
        set_year_to_latest
      else
        @year = year
      end
      populate
    end

    def populate # [ country, value ]
      @data = query
      raise "No data available for #{@year}" unless @data
      @data = @data.select { |d| d[1] } # discard null values
    end

    def to_i_or_nil(str)
      str ? str.to_i : nil
    end
    def to_f_or_nil(str)
      str ? str.to_f : nil
    end
    def to_a
      @data
    end
    def title
      "#{@id}, #{@year} (World Bank Development Indicators)"
    end

    private
    def query
      response = raw_query(number_of_datapoints)
      response ? response['data']['data'].collect { |h| [ h['country']['__content__'], to_f_or_nil(h['value']) ] } : nil
    end

    def set_year_to_latest
      Date.today.year.downto(OLDEST_YEAR) do |year|
        # Possibilities:
        #   Error that this date isn't on the system
        #   Normal output with nil for every country
        #   Good data
        @year = year
        data = query
        return true if data and data.select { |d| d[1] }.length >= MINIMUM_NUMBER_OF_VALUES
      end
      raise "No data available for any year between #{Date.today.year} and #{OLDEST_YEAR}"
    end

    def number_of_datapoints
      info=raw_query(10)
      return nil unless info
      info['data']['total']
    end
    def raw_query(page_length=500) # will return nil if nothing available for that year
      #options.merge!({page: 1, per_page: 500})
      answer = self.class.get("/countries/all/indicators/#{@id}?date=#{@year}&per_page=#{page_length}")
      if answer.code != 200
        puts "WB query failed.  Response:"
        puts answer
        exit 1
      end
      if answer['error']
        detail = answer['error']['message']['__content__']
        raise "Error querying WB API: #{detail}"
      end
      unless answer['data']['data']
        return nil if answer['data']['total'] == '0'
        begin
          raise "Unexpected response from WB API"
        rescue
          binding.pry
        end
      end
      answer
    end
  end
end

###########################################################################################
# Response and errors
###########################################################################################
#
# All of these responses are class HTTParty::Response
# 
# Normal response: answer['data']['data']
# answer.code: 200
# 
# => {"data"=>
#   {"page"=>"1",
#    "pages"=>"1",
#    "per_page"=>"500",
#    "total"=>"264",
#    "xmlns:wb"=>"http://www.worldbank.org",
#    "data"=>
#     [{"indicator"=>{"id"=>"NV.IND.TOTL.ZS", "__content__"=>"Industry, value added (% of GDP)"},
#       "country"=>{"id"=>"1A", "__content__"=>"Arab World"},
#       "date"=>"2010",
#       "value"=>"52.4047484049162",
#       "decimal"=>"1"},
#      {"indicator"=>{"id"=>"NV.IND.TOTL.ZS", "__content__"=>"Industry, value added (% of GDP)"},
#       "country"=>{"id"=>"S3", "__content__"=>"Caribbean small states"},
#       "date"=>"2010",
#       "value"=>"33.6070159372035",
#       "decimal"=>"1"},
#      {"indicator"=>{"id"=>"NV.IND.TOTL.ZS", "__content__"=>"Industry, value added (% of GDP)"},
#       "country"=>{"id"=>"B8", "__content__"=>"Central Europe and the Baltics"},
#       "date"=>"2010",
#       "value"=>"33.6461625696823",
#       "decimal"=>"1"},
#      {"indicator"=>{"id"=>"NV.IND.TOTL.ZS", "__content__"=>"Industry, value added (% of GDP)"},
#       "country"=>{"id"=>"V2", "__content__"=>"Early-demographic dividend"},
#       "date"=>"2010",
#       "value"=>"36.1346276219024",
#       "decimal"=>"1"},
#       ...
# 
# Normal error: answer['error']['message']['__content__']
# answer.code: 200
# 
# If you ask for a non-existent indicator, this is the response:
# 
# => {"error"=>
#   {"xmlns:wb"=>"http://www.worldbank.org",
#    "message"=>
#     {"id"=>"120",
#      "key"=>
#       "Parameter ' Updates to the WDI & GDF database may contain revisions to indicator coverage. \r# \n\t\t\t\t\t\tVisit -> \"http://data.worldbank.org/about/data-updates-errata\"  to see the # latest list of additions, deletions, \r\n\t\t\tand changes in codes, descriptions, # definitions, sources and topics. ' has an invalid value",
#      "__content__"=>"The provided parameter value is not valid"}}}
# 
# 
# Wonky error
# answer.code: 400
# 
# A server error will result in an HTML response, even if JSON is requested.
# This will happen if the page_length is out of range
# 
# Example:
# [8] pry(#<Cory::DataCatalog>)> answer = self.class.get("/countries/all/# indicators/#{id}?date=2010&per_page=50000&type=json")
# => "\xEF\xBB\xBF<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD # XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<# html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n  <head>\r\n    <title>Request Error</title>\r\n#     <style>BODY { color: #000000; background-color: white; font-family: Verdana; margin-left: # 0px; margin-top: 0px; } #content { margin-left: 30px; font-size: .70em; padding-bottom: 2em; } # A:link { color: #336699; font-weight: bold; text-decoration: underline; } A:visited { color: # #6699cc; font-weight: bold; text-decoration: underline; } A:active { color: #336699; font-weight: # bold; text-decoration: underline; } .heading1 { background-color: #003366; border-bottom: #336699 # 6px solid; color: #ffffff; font-family: Tahoma; font-size: 26px; font-weight: normal;margin: 0em # 0em 10px -20px; padding-bottom: 8px; padding-left: 30px;padding-top: 16px;} pre { # font-size:small; background-color: #e5e5cc; padding: 5px; font-family: Courier New; margin-top: # 0px; border: 1px #f0f0e0 solid; white-space: pre-wrap; white-space: -pre-wrap; word-wrap: # break-word; } table { border-collapse: collapse; border-spacing: 0px; font-family: Verdana;} # table th { border-right: 2px white solid; border-bottom: 2px white solid; font-weight: bold; # background-color: #cecf9c;} table td { border-right: 2px white solid; border-bottom: 2px white # solid; background-color: #e5e5cc;}</style>\r\n  </head>\r\n  <body>\r\n    <div id=\"content\">\r# \n      <p class=\"heading1\">Request Error</p>\r\n      <p>The server encountered an error # processing the request. See server logs for more details.</p>\r\n    </div>\r\n  </body>\r\n</# html>"
# 
#
# Fail without error: answer['data']['total'] == 0
# 
# E.g. request future information
# 
# raw_query 'SP.POP.TOTL', 2020
# 
# [1] pry(#<Cory::DataCatalog>)> answer
# => {"data"=>{"page"=>"0", "pages"=>"0", "total"=>"0"}}
#
###########################################################################################
# Request Format
###########################################################################################
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