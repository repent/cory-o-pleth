# Cory O'Pleth

A command-line tool for converting csv data into choropleth maps.

## Installation

    gem install i18n awesome_print pry

## Usage

    Usage: ruby -I lib bin/cory [options] input
        -b, --basket                     Group countries into discrete baskets (default: linear-ish interpolation, see docs)
        -c, --countries FILE             Take country name data from FILE (a CSV file)
        -d, --print-discards             Print country names that aren's matched
        -h, --help                       Print this help
        -H, --header                     Ignore first line of CSV input
        -l, --log LEVEL                  Set log level (from debug, info, warn, error, fatal)
        -L, --logfile FILE               Log to FILE instead of standard error
        -m, --map FILE                   Map file (must have tag indicating where to insert CSS)
        -n, --colour-levels N            Number of colour levels to use (more important when used with     -b) -- the options available are limited by your chosen palette (-p)
        -p, --palette PALETTE            Palette (set of colours) to use (must be one of available     options)
        -R, --reverse                    Reverse palette
        -v, --verbose                    Display verbose output
        -w, --warn                       Don't overwrite any output files
        -W, --world-bank [INDICATOR]     Use INDICATOR from the World Bank Development Indicators as your source
        -y, --year                       Year of data to select for World Bank queries

For example output, see https://en.wikipedia.org/wiki/File:Doing_business_2017.svg

## Examples

### Africa visa openness 2016

Input data: https://gist.github.com/repent/85ac63da2e99d057cc07977ca94bd5dd (saved in stats/)

Output: https://commons.wikimedia.org/wiki/File:Africa_Visa_Openness_in_2016.svg

Command:

    ruby -I lib bin/cory -b -n 7 stats/africa_visa_openness_2016.csv -m maps/BlankMap-Africa-cory.svg -p RdYlGn -o africa_visa_openness_2016.svg

### Direct use of WB data

You can query the World Bank's Development Indicator API directly to skip downloading source data.

For instance, to show countries' populations in seven baskets:

    ruby -I lib bin/cory -b -p Blues -n 7 -W SP.POP.TOTL population-map.svg

## Contributions and licensing

### Cory O'Pleth

Cory O'Pleth is copyright 2017 Dan Hetherington.

Cory O'Pleth is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Cory O'Pleth is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

### Maps

Maps included with Cory O'Pleth are distributed under the following licences:

 * BlankMap-World6.svg: public domain
 * BlankMap-World8.svg: public domain
 * BlankMap-Africa.svg: public domain
 * Blank_map_of_Europe_cropped: CC Attribution-Share Alike 2.5 Generic (https://creativecommons.org/licenses/by-sa/2.5/deed.en); map by Maix based on work by Julio Reis
 * Greater London constituency map (blank) simple.svg: based on Greater London UK constituency map (blank).svg, CC Attribution-Share Alike 3.0 Unported, which contains Ordnance Survey data (c) Crown copyright and database right

### Colorbrewer

This product includes colour specifications and designs developed by Cynthia Brewer (http://colorbrewer2.org/).  These are licensed under the Apache Licence, Version 2.0, available from
http://www.apache.org/licenses/LICENSE-2.0

The following conditions apply:

Apache-Style Software License for ColorBrewer software and ColorBrewer Color Schemes

Copyright (c) 2002 Cynthia Brewer, Mark Harrower, and The Pennsylvania State University.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions as source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. The end-user documentation included with the redistribution, if any, must include the following acknowledgment: "This product includes color specifications and designs developed by Cynthia Brewer (http://colorbrewer.org/)." Alternately, this acknowledgment may appear in the software itself, if and wherever such third-party acknowledgments normally appear.

4. The name "ColorBrewer" must not be used to endorse or promote products derived from this software without prior written permission. For written permission, please contact Cynthia Brewer at cbrewer@psu.edu.

5. Products derived from this software may not be called "ColorBrewer", nor may "ColorBrewer" appear in their name, without prior written permission of Cynthia Brewer.