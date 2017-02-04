#!/usr/bin/ruby

# Bugs
# * For some reason Ukraine isn't shaded!

require 'csv'
require 'pry'
require 'ostruct'

log = Logger.new($stout)
log.level = Logger::ERROR



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