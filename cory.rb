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
  colour_rule: :interpolate, # c.f. basket
  output: 'output.svg',
  becareful: false,
  colour_set: :traffic_lights,
  map: 'BlankMap-World8-cory.svg',
)

colours = ['#edf8b1','#7fcdbb','#2c7fb8']

log.debug("Parsing options")

OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] output"
  
  opts.on('-b', '--basket', 'Group countries into discrete baskets (default: linear-ish interpolation, see docs)') { raise "Not implemented"; options.colour_rule = :basket }
  opts.on('-cFILE', '--countries=FILE', 'Take country name data from FILE (a CSV file)') { |f| options.county_data = f }
  opts.on('-CSET', '--colour=SET', 'Colour set to use (must be one of available options)') { |set| options.colour_set = set.to_sym }
  #opts.on('--list-colours', 'List available colour sets') { }
  opts.on('-d', '--dry-run', 'Make no changes, just display what would be done and exit') { options.dry = true }
  opts.on('-h', '--help', 'Print this help') { puts opts; exit }
  opts.on('-iFILE', '--input=FILE', 'Take choropleth data from FILE (a CSV file)') { |f| options.input_data = f }
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
  opts.on('-mFILE', '--map=FILE', 'Map file (must have tag indicating where to insert CSS)') { |m| options.map = m }
  opts.on('-v', '--verbose', 'Display verbose output') { options.verbose = true }
  opts.on('-w', '--warn', "Don't overwrite any output files") { options.becareful == true }

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

options.output = ARGV[0] if ARGV[0]

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



class Colour
  # internal: @a = [4, 104, 212] = [r,g,b]
  def initialize(parms=nil, *extra)
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
    when nil
      @a = [0,0,0]
    else
      raise "Unknown colour type #{parms.to_s}"
    end
  end
  def []=(index, new_colour)
    @a[index]=new_colour
  end
  def [](index)
    @a[index]
  end
  def to_hex
    #binding.pry
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

  private
  def to_h(n)
    # in case n is a float
    n.round.to_s(16).rjust(2, '0')
  end
  def to_d(s)
    s.to_i(16)
  end
end

class Scale
  def initialize(points) # array of colours
    # 2+ coordinates
    raise "Invalid scale #{points}" unless points.class.name === 'Array' and points.length > 1
    @points=points
  end
  #def *(index)
  ##  # linear interpolation
  ##  # find two closest points
  ##  # interpolate
  ##  interpolate(index)
  #end
  def *(i)
    x_n = closest(i)
    x = x_n.collect{ |j| j*spacing }
    y = [ @points[x_n[0]],@points[x_n[1]] ]
    result = Colour.new
    # edge case that causes problems: bang on a point in the scale (so x[1]-x[0] is divide-by-zero)
    return @points[x_n[0]] if x_n[0] == x_n[1]
    # for each element of a colour (r,g,b)
    [0,1,2].each do |colour|
      proportion = (i - x[0]) / (x[1] - x[0])
      #binding.pry
      result[colour] = y[0][colour] + proportion * (y[1][colour] - y[0][colour])
      binding.pry if result[colour].nan?
    end
    result
  end
  def spacing
    100.0 / (@points.length-1)
  end
  def closest(index)
    ##puts "spacing: #{spacing}"
    #under,over=100,0
    #0.upto(@points.length-1) do |n|
    #  x=n*spacing
    #  #puts "under: #{under}; over: #{over}; index: #{index}; x: #{x}"
    #  under = x if x < index
    #  over = (100 - x) if (100 - x) > index
    #end
    #puts "#{[under,over]}.to_s"
    #puts under, over, index
    under,over=@points.length,0
    0.upto(@points.length-1) do |n|
      under = n if n <= (index / spacing)
      over = (@points.length - n) if (@points.length - n) >= (index / spacing)
    end
    [under,over]
  end
end

scales = {
  # Traffic lights
  # Source: colourbrewer2.org
  # Copyright Cynthir Brewer, Mark Harrower and the Pennsylvania State University
  traffic_lights: Scale.new( [
    Colour.new(165,0,38),
    Colour.new(215,48,39),
    Colour.new(244,109,67),
    Colour.new(253,174,97),
    Colour.new(254,224,139),
    Colour.new(255,255,191),
    Colour.new(217,239,139),
    Colour.new(166,217,106),
    Colour.new(102,189,99),
    Colour.new(26,152,80),
    Colour.new(0,104,55),
  ] )
}

#a=Colour.new('#0000ff')
#b=Colour.new('#00ff00')
#c=Colour.new('ff0000')
#
#s=Scale.new [a,b,c]
#
##a=Colour.new '2c7fb8'
##b=Colour.new '#edf8b1'
##c=Colour.new [0, 255, 0]
##s=Scale.new [a,b]
##binding.pry
#
#binding.pry

#puts (traffic*1).to_hex

#exit

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
    #binding.pry if @code==''
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

#input = 'gdp.csv'
country_file = 'country-codes.csv'

data = CSV.read options.input_data
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
    index = ((value - min) / diff) * 100
    # Output CSS
    colour = scales[options.colour_set]*index
    css.push ".#{countries.translate(country)} { fill: ##{colour.to_hex}; }"
  rescue
    binding.pry
  end
  end
end

# Inject CSS into a map

#binding.pry

source = File.readlines(options.map)

if File.exist? options.output and options.becareful
  puts "#{options.output} already exists and 'warn' option has been set, exiting"
  exit
end

output = File.new(options.output, 'w')

source.each do |l|
  if l =~ /^INJECT-CSS/i
    css.each do |m|
      output.puts m
    end
  else
    output.puts l
  end
end