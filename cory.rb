#!/usr/bin/ruby

# Bugs
# * For some reason Ukraine isn't shaded!

require 'csv'
require 'pry'
require 'optparse'
require 'ostruct'
require 'logger'

log = Logger.new($stout)
log.level = Logger::ERROR

#module Logging
#  # This is the magical bit that gets mixed into your classes
#  def logger
#    Logging.logger
#  end
#
#  # Global, memoized, lazy initialized instance of a logger
#  def self.logger
#    @logger ||= Logger.new(STDOUT)
#  end
#end

options = OpenStruct.new(
  verbose: false,
  dry: false,
  # Display options
  circles: true,
  input_data: 'data.csv',
  country_data: 'country-codes.csv',
)

colours = ['#edf8b1','#7fcdbb','#2c7fb8']

log.debug("Parsing options")

OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] file1 file1 file3 ..."
  
  opts.on('-h', '--help', 'Print this help') { puts opts; exit }
  opts.on('-v', '--verbose', 'Display verbose output') { options.verbose = true }
  opts.on('-d', '--dry-run', 'Make no changes, just display what would be done and exit') { options.dry = true }
  opts.on('-lLEVEL', '--log=LEVEL', 'Set log level (from debug, info, warn, error, fatal)') do |level|
    log.level = case level
      when 'debug', 4
        Logger::DEBUG
      when 'info', 3
        Logger::INFO
      when 'warn', 2
        Logger::WARN
      when 'error', 1
        Logger::ERROR
      when 'fatal', 0
        Logger::FATAL
      else
        raise 'Log level must be one of debug, info, warn, error, or fatal'
    end
  end
  opts.on('-LFILE', '--logfile=FILE', 'Log to FILE instead of standard error') { |f| log.reopen(f) }
  opts.on('-iFILE', '--input=FILE', 'Take choropleth data from FILE (a CSV file)') { |f| options.input_data = f }
  opts.on('-cFILE', '--countries=FILE', 'Take country name data from FILE (a CSV file)') { |f| options.county_data = f }

  begin
    opts.parse!
  rescue OptionParser::ParseError => error
    # Without this rescue, Ruby would print the stack trace
    # of the error. Instead, we want to show the error message,
    # suggest -h or --help, and exit 1.
 
    $stderr.puts error
    $stderr.puts "(-h or --help will show valid options)"
    exit 1
  end
end

options.verbose = true if options.dry

log.debug("Started #{$0}")

# Colorbrewer2.org
# Yellow/Blue
# Light
#edf8b1
#7fcdbb
#2c7fb8
# Dark

# Brown
#fff7bc
#fec44f
#d95f0e

# Traffic lights
# 165,0,38
# 215,48,39
# 244,109,67
# 253,174,97
# 254,224,139
# 255,255,191
# 217,239,139
# 166,217,106
# 102,189,99
# 26,152,80
# 0,104,55

class Colour
  # internal: @a = [4, 104, 212] = [r,g,b]
  def initialize(parms, *extra)
    if extra[0]
      parms = [parms]+extra
    end
    case parms
    when String
      s = parms.gsub '#', ''
      raise "Bad colour #{parms}" unless s.length == 6
      h_arr=s[0,2],s[2,2],s[4,2]
      @a = h_arr.collect{ |x| to_d(x) }
    when Array
      raise "Bad colour #{parms}" unless parms.count == 3
      @a = parms.collect {|i| i.to_f.round }
    else
      raise "Unknown colour type #{parms.to_s}"
    end
  end
  def to_h(n)
    n.to_s(16).rjust(2)
  end
  def to_d(s)
    s.to_i(16)
  end
  def hex
    @a.collect{ |x| to_h(x)}.join
  end
  def r; @a[0]; end
  def g; @a[1]; end
  def b; @a[2]; end
  def +(o)
    Colour.new(r+o.r, g+o.g, b+o.b)
  end
  def -(o)
    Colour.new(r-o.r, g-o.g, b-o.b)
  end
end

class Scale

end

a=Colour.new '2c7fb8'
b=Colour.new '#edf8b1'
c=Colour.new [0, 255, 0]
binding.pry

class Country
  def initialize(data) # first: alpha-2 code, remainder: synonyms
    #binding.pry
    @code = data.to_a.shift.downcase
    raise unless @code
    @synonyms = data.collect{|d| d.gsub(/[\.\,]/,'') if d}
  end
  def add(synonym)
    @synonyms = @synonyms + [ synonym ].flatten
  end
  def synonyms
    return [@code]+@synonyms
  end
  def match?(string)
    simple_string = string.gsub(/[\.\,]/,'')
    binding.pry if @code==''
    #binding.pry if string =~ /icro/ && @code=='fm'
    synonyms.include? simple_string
  end
  def to_s
    @code
  end
end

class Countries
  #include Logging
  def initialize(cd)
    @countries = cd.collect { |i| Country.new(i) }
    @missing = Logger.new('country_names_not_found.log')
  end
  def translate(name)
    @countries.each do |c|
      return c.to_s if c.match? name
    end
    @missing.warn(name)
    false
  end
  def has?(country)
    translate(country) ? true : false
  end
end

input = 'gdp.csv'
country_file = 'country-codes.csv'

data = CSV.read input
country_data = CSV.read(country_file) #, { headers: true })
country_data.shift # ditch header
countries = Countries.new(country_data)

# check data and find upper and lower bounds

max,min=nil,nil

data.each do |line|
  country,value,junk=line
  # ---Check-country-validates--- (done inside Countries)
  # Check there is no extraneous data
  #puts "Found additional data (#{junk})" if junk
  # Nudge upper/lower bounds
  begin
  if value # ignore nils
    value = value.to_f
    max ||= value
    min ||= value
    max = value if value > max
    min = value if value < min
  end
  rescue
    binding.pry
  end
end

binding.pry

css = []
diff = max - min

data.each do |line|
  country,value=line
  if value then value = value.to_f else next end
  if countries.has?(country)
    begin
    # Look up the 2-letter iso code for the country
    # Convert the raw number into a colour code
    hex = (((value - min) / diff) * 255).round.to_s(16).rjust(2,'0')
    # Output CSS
    css.push ".#{countries.translate(country)} { fill: #00#{hex}00 }"
  rescue
    binding.pry
  end
  end
end

# Inject CSS into a map

#binding.pry

source = File.readlines('BlankMap-World8-cory.svg')

output = File.new('cory.svg', 'w')

source.each do |l|
  if l =~ /^INJECT-CSS/i
    css.each do |m|
      output.puts m
    end
  else
    output.puts l
  end
end