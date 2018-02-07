#!/usr/bin/ruby

require 'builder'

File.open('svgtest.html', 'wt') do |svg_legend|
  legend = Builder::XmlMarkup.new( target: svg_legend, indent: 2 )
  legend.instruct! :xml, encoding: 'UTF-8'
  #<svg xmlns:cc="http://web.resource.org/cc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg" version="1.1" height="1000" width="1000">
  legend.html do
    legend.body do
      legend.svg(version: '1.1', height: '1000', width: '1000') do
    
        position = 0
        side, spacing = 50, 10
        legend.rect x: 0, y: position, height: side, width: side, fill: 'black'
        #legend.text x: 0, y: position, class: 'legend_text'
        position += side + spacing
      end
    end
  end
end

File.readlines('svgtest.svg').each do |l|
  puts l
end