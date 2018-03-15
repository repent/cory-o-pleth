# Alternative formats:
# symbolic_name => [
#   [ [r,g,b], [r2,g2,b2], ... ]
#   rgb_array_of_different_length
#   ...
# ]
# symbolic_name => [
#   [ hex_string, hex_string, ... ]
#   [ hex_string, hex_string, ... different number ... ]
# ]


Cory::PALETTES = {
  berf_plum: [
    [ [142,37,141] ],
  ],

  YlGn: [
    ["#f7fcb9","#addd8e","#31a354"],
    ["#ffffcc","#c2e699","#78c679","#238443"],
    ["#ffffcc","#c2e699","#78c679","#31a354","#006837"],
    ["#ffffcc","#d9f0a3","#addd8e","#78c679","#31a354","#006837"],
    ["#ffffcc","#d9f0a3","#addd8e","#78c679","#41ab5d","#238443","#005a32"],
    ["#ffffe5","#f7fcb9","#d9f0a3","#addd8e","#78c679","#41ab5d","#238443","#005a32"],
    ["#ffffe5","#f7fcb9","#d9f0a3","#addd8e","#78c679","#41ab5d","#238443","#006837","#004529"]
  ],
  YlGnBu: [
    ["#edf8b1","#7fcdbb","#2c7fb8"],
    ["#ffffcc","#a1dab4","#41b6c4","#225ea8"],
    ["#ffffcc","#a1dab4","#41b6c4","#2c7fb8","#253494"],
    ["#ffffcc","#c7e9b4","#7fcdbb","#41b6c4","#2c7fb8","#253494"],
    ["#ffffcc","#c7e9b4","#7fcdbb","#41b6c4","#1d91c0","#225ea8","#0c2c84"],
    ["#ffffd9","#edf8b1","#c7e9b4","#7fcdbb","#41b6c4","#1d91c0","#225ea8","#0c2c84"],
    ["#ffffd9","#edf8b1","#c7e9b4","#7fcdbb","#41b6c4","#1d91c0","#225ea8","#253494","#081d58"]
  ],
  GnBu: [
    ["#e0f3db","#a8ddb5","#43a2ca"],
    ["#f0f9e8","#bae4bc","#7bccc4","#2b8cbe"],
    ["#f0f9e8","#bae4bc","#7bccc4","#43a2ca","#0868ac"],
    ["#f0f9e8","#ccebc5","#a8ddb5","#7bccc4","#43a2ca","#0868ac"],
    ["#f0f9e8","#ccebc5","#a8ddb5","#7bccc4","#4eb3d3","#2b8cbe","#08589e"],
    ["#f7fcf0","#e0f3db","#ccebc5","#a8ddb5","#7bccc4","#4eb3d3","#2b8cbe","#08589e"],
    ["#f7fcf0","#e0f3db","#ccebc5","#a8ddb5","#7bccc4","#4eb3d3","#2b8cbe","#0868ac","#084081"]
  ],
  BuGn: [
    ["#e5f5f9","#99d8c9","#2ca25f"],
    ["#edf8fb","#b2e2e2","#66c2a4","#238b45"],
    ["#edf8fb","#b2e2e2","#66c2a4","#2ca25f","#006d2c"],
    ["#edf8fb","#ccece6","#99d8c9","#66c2a4","#2ca25f","#006d2c"],
    ["#edf8fb","#ccece6","#99d8c9","#66c2a4","#41ae76","#238b45","#005824"],
    ["#f7fcfd","#e5f5f9","#ccece6","#99d8c9","#66c2a4","#41ae76","#238b45","#005824"],
    ["#f7fcfd","#e5f5f9","#ccece6","#99d8c9","#66c2a4","#41ae76","#238b45","#006d2c","#00441b"]
  ],
  PuBuGn: [
    ["#ece2f0","#a6bddb","#1c9099"],
    ["#f6eff7","#bdc9e1","#67a9cf","#02818a"],
    ["#f6eff7","#bdc9e1","#67a9cf","#1c9099","#016c59"],
    ["#f6eff7","#d0d1e6","#a6bddb","#67a9cf","#1c9099","#016c59"],
    ["#f6eff7","#d0d1e6","#a6bddb","#67a9cf","#3690c0","#02818a","#016450"],
    ["#fff7fb","#ece2f0","#d0d1e6","#a6bddb","#67a9cf","#3690c0","#02818a","#016450"],
    ["#fff7fb","#ece2f0","#d0d1e6","#a6bddb","#67a9cf","#3690c0","#02818a","#016c59","#014636"]
  ],
  PuBu: [
    ["#ece7f2","#a6bddb","#2b8cbe"],
    ["#f1eef6","#bdc9e1","#74a9cf","#0570b0"],
    ["#f1eef6","#bdc9e1","#74a9cf","#2b8cbe","#045a8d"],
    ["#f1eef6","#d0d1e6","#a6bddb","#74a9cf","#2b8cbe","#045a8d"],
    ["#f1eef6","#d0d1e6","#a6bddb","#74a9cf","#3690c0","#0570b0","#034e7b"],
    ["#fff7fb","#ece7f2","#d0d1e6","#a6bddb","#74a9cf","#3690c0","#0570b0","#034e7b"],
    ["#fff7fb","#ece7f2","#d0d1e6","#a6bddb","#74a9cf","#3690c0","#0570b0","#045a8d","#023858"]
  ],
  BuPu: [
    ["#e0ecf4","#9ebcda","#8856a7"],
    ["#edf8fb","#b3cde3","#8c96c6","#88419d"],
    ["#edf8fb","#b3cde3","#8c96c6","#8856a7","#810f7c"],
    ["#edf8fb","#bfd3e6","#9ebcda","#8c96c6","#8856a7","#810f7c"],
    ["#edf8fb","#bfd3e6","#9ebcda","#8c96c6","#8c6bb1","#88419d","#6e016b"],
    ["#f7fcfd","#e0ecf4","#bfd3e6","#9ebcda","#8c96c6","#8c6bb1","#88419d","#6e016b"],
    ["#f7fcfd","#e0ecf4","#bfd3e6","#9ebcda","#8c96c6","#8c6bb1","#88419d","#810f7c","#4d004b"]
  ],
  RdPu: [
    ["#fde0dd","#fa9fb5","#c51b8a"],
    ["#feebe2","#fbb4b9","#f768a1","#ae017e"],
    ["#feebe2","#fbb4b9","#f768a1","#c51b8a","#7a0177"],
    ["#feebe2","#fcc5c0","#fa9fb5","#f768a1","#c51b8a","#7a0177"],
    ["#feebe2","#fcc5c0","#fa9fb5","#f768a1","#dd3497","#ae017e","#7a0177"],
    ["#fff7f3","#fde0dd","#fcc5c0","#fa9fb5","#f768a1","#dd3497","#ae017e","#7a0177"],
    ["#fff7f3","#fde0dd","#fcc5c0","#fa9fb5","#f768a1","#dd3497","#ae017e","#7a0177","#49006a"]
    ],
    PuRd: [
    ["#e7e1ef","#c994c7","#dd1c77"],
    ["#f1eef6","#d7b5d8","#df65b0","#ce1256"],
    ["#f1eef6","#d7b5d8","#df65b0","#dd1c77","#980043"],
    ["#f1eef6","#d4b9da","#c994c7","#df65b0","#dd1c77","#980043"],
    ["#f1eef6","#d4b9da","#c994c7","#df65b0","#e7298a","#ce1256","#91003f"],
    ["#f7f4f9","#e7e1ef","#d4b9da","#c994c7","#df65b0","#e7298a","#ce1256","#91003f"],
    ["#f7f4f9","#e7e1ef","#d4b9da","#c994c7","#df65b0","#e7298a","#ce1256","#980043","#67001f"]
    ],
    OrRd: [
    ["#fee8c8","#fdbb84","#e34a33"],
    ["#fef0d9","#fdcc8a","#fc8d59","#d7301f"],
    ["#fef0d9","#fdcc8a","#fc8d59","#e34a33","#b30000"],
    ["#fef0d9","#fdd49e","#fdbb84","#fc8d59","#e34a33","#b30000"],
    ["#fef0d9","#fdd49e","#fdbb84","#fc8d59","#ef6548","#d7301f","#990000"],
    ["#fff7ec","#fee8c8","#fdd49e","#fdbb84","#fc8d59","#ef6548","#d7301f","#990000"],
    ["#fff7ec","#fee8c8","#fdd49e","#fdbb84","#fc8d59","#ef6548","#d7301f","#b30000","#7f0000"]
    ],
    YlOrRd: [
    ["#ffeda0","#feb24c","#f03b20"],
    ["#ffffb2","#fecc5c","#fd8d3c","#e31a1c"],
    ["#ffffb2","#fecc5c","#fd8d3c","#f03b20","#bd0026"],
    ["#ffffb2","#fed976","#feb24c","#fd8d3c","#f03b20","#bd0026"],
    ["#ffffb2","#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"],
    ["#ffffcc","#ffeda0","#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"],
    ["#ffffcc","#ffeda0","#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#bd0026","#800026"]
    ],
    YlOrBr: [
    ["#fff7bc","#fec44f","#d95f0e"],
    ["#ffffd4","#fed98e","#fe9929","#cc4c02"],
    ["#ffffd4","#fed98e","#fe9929","#d95f0e","#993404"],
    ["#ffffd4","#fee391","#fec44f","#fe9929","#d95f0e","#993404"],
    ["#ffffd4","#fee391","#fec44f","#fe9929","#ec7014","#cc4c02","#8c2d04"],
    ["#ffffe5","#fff7bc","#fee391","#fec44f","#fe9929","#ec7014","#cc4c02","#8c2d04"],
    ["#ffffe5","#fff7bc","#fee391","#fec44f","#fe9929","#ec7014","#cc4c02","#993404","#662506"]
    ],
    Purples: [
    ["#efedf5","#bcbddc","#756bb1"],
    ["#f2f0f7","#cbc9e2","#9e9ac8","#6a51a3"],
    ["#f2f0f7","#cbc9e2","#9e9ac8","#756bb1","#54278f"],
    ["#f2f0f7","#dadaeb","#bcbddc","#9e9ac8","#756bb1","#54278f"],
    ["#f2f0f7","#dadaeb","#bcbddc","#9e9ac8","#807dba","#6a51a3","#4a1486"],
    ["#fcfbfd","#efedf5","#dadaeb","#bcbddc","#9e9ac8","#807dba","#6a51a3","#4a1486"],
    ["#fcfbfd","#efedf5","#dadaeb","#bcbddc","#9e9ac8","#807dba","#6a51a3","#54278f","#3f007d"]
    ],
    Blues: [
      # Added central colour as a 1 (temporay fix to #16)
      #["#9ecae1"],
      # That was a bit light, try the darkest of the 3 (better)
      ["#3182bd"],
      ["#deebf7","#9ecae1","#3182bd"],
      ["#eff3ff","#bdd7e7","#6baed6","#2171b5"],
      ["#eff3ff","#bdd7e7","#6baed6","#3182bd","#08519c"],
      ["#eff3ff","#c6dbef","#9ecae1","#6baed6","#3182bd","#08519c"],
      ["#eff3ff","#c6dbef","#9ecae1","#6baed6","#4292c6","#2171b5","#084594"],
      ["#f7fbff","#deebf7","#c6dbef","#9ecae1","#6baed6","#4292c6","#2171b5","#084594"],
      ["#f7fbff","#deebf7","#c6dbef","#9ecae1","#6baed6","#4292c6","#2171b5","#08519c","#08306b"]
    ],
    Greens: [
    ["#e5f5e0","#a1d99b","#31a354"],
    ["#edf8e9","#bae4b3","#74c476","#238b45"],
    ["#edf8e9","#bae4b3","#74c476","#31a354","#006d2c"],
    ["#edf8e9","#c7e9c0","#a1d99b","#74c476","#31a354","#006d2c"],
    ["#edf8e9","#c7e9c0","#a1d99b","#74c476","#41ab5d","#238b45","#005a32"],
    ["#f7fcf5","#e5f5e0","#c7e9c0","#a1d99b","#74c476","#41ab5d","#238b45","#005a32"],
    ["#f7fcf5","#e5f5e0","#c7e9c0","#a1d99b","#74c476","#41ab5d","#238b45","#006d2c","#00441b"]
    ],
    Oranges: [
    ["#fee6ce","#fdae6b","#e6550d"],
    ["#feedde","#fdbe85","#fd8d3c","#d94701"],
    ["#feedde","#fdbe85","#fd8d3c","#e6550d","#a63603"],
    ["#feedde","#fdd0a2","#fdae6b","#fd8d3c","#e6550d","#a63603"],
    ["#feedde","#fdd0a2","#fdae6b","#fd8d3c","#f16913","#d94801","#8c2d04"],
    ["#fff5eb","#fee6ce","#fdd0a2","#fdae6b","#fd8d3c","#f16913","#d94801","#8c2d04"],
    ["#fff5eb","#fee6ce","#fdd0a2","#fdae6b","#fd8d3c","#f16913","#d94801","#a63603","#7f2704"]
    ],
    Reds: [
    ["#fee0d2","#fc9272","#de2d26"],
    ["#fee5d9","#fcae91","#fb6a4a","#cb181d"],
    ["#fee5d9","#fcae91","#fb6a4a","#de2d26","#a50f15"],
    ["#fee5d9","#fcbba1","#fc9272","#fb6a4a","#de2d26","#a50f15"],
    ["#fee5d9","#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d","#99000d"],
    ["#fff5f0","#fee0d2","#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d","#99000d"],
    ["#fff5f0","#fee0d2","#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d","#a50f15","#67000d"]
    ],
    Greys: [
    ["#f0f0f0","#bdbdbd","#636363"],
    ["#f7f7f7","#cccccc","#969696","#525252"],
    ["#f7f7f7","#cccccc","#969696","#636363","#252525"],
    ["#f7f7f7","#d9d9d9","#bdbdbd","#969696","#636363","#252525"],
    ["#f7f7f7","#d9d9d9","#bdbdbd","#969696","#737373","#525252","#252525"],
    ["#ffffff","#f0f0f0","#d9d9d9","#bdbdbd","#969696","#737373","#525252","#252525"],
    ["#ffffff","#f0f0f0","#d9d9d9","#bdbdbd","#969696","#737373","#525252","#252525","#000000"]
    ],
    PuOr: [
    ["#f1a340","#f7f7f7","#998ec3"],
    ["#e66101","#fdb863","#b2abd2","#5e3c99"],
    ["#e66101","#fdb863","#f7f7f7","#b2abd2","#5e3c99"],
    ["#b35806","#f1a340","#fee0b6","#d8daeb","#998ec3","#542788"],
    ["#b35806","#f1a340","#fee0b6","#f7f7f7","#d8daeb","#998ec3","#542788"],
    ["#b35806","#e08214","#fdb863","#fee0b6","#d8daeb","#b2abd2","#8073ac","#542788"],
    ["#b35806","#e08214","#fdb863","#fee0b6","#f7f7f7","#d8daeb","#b2abd2","#8073ac","#542788"],
    ["#7f3b08","#b35806","#e08214","#fdb863","#fee0b6","#d8daeb","#b2abd2","#8073ac","#542788","#2d004b"],
    ["#7f3b08","#b35806","#e08214","#fdb863","#fee0b6","#f7f7f7","#d8daeb","#b2abd2","#8073ac","#542788","#2d004b"]
    ],
    BrBG: [
    ["#d8b365","#f5f5f5","#5ab4ac"],
    ["#a6611a","#dfc27d","#80cdc1","#018571"],
    ["#a6611a","#dfc27d","#f5f5f5","#80cdc1","#018571"],
    ["#8c510a","#d8b365","#f6e8c3","#c7eae5","#5ab4ac","#01665e"],
    ["#8c510a","#d8b365","#f6e8c3","#f5f5f5","#c7eae5","#5ab4ac","#01665e"],
    ["#8c510a","#bf812d","#dfc27d","#f6e8c3","#c7eae5","#80cdc1","#35978f","#01665e"],
    ["#8c510a","#bf812d","#dfc27d","#f6e8c3","#f5f5f5","#c7eae5","#80cdc1","#35978f","#01665e"],
    ["#543005","#8c510a","#bf812d","#dfc27d","#f6e8c3","#c7eae5","#80cdc1","#35978f","#01665e","#003c30"],
    ["#543005","#8c510a","#bf812d","#dfc27d","#f6e8c3","#f5f5f5","#c7eae5","#80cdc1","#35978f","#01665e","#003c30"]
    ],
    PRGn: [
    ["#af8dc3","#f7f7f7","#7fbf7b"],
    ["#7b3294","#c2a5cf","#a6dba0","#008837"],
    ["#7b3294","#c2a5cf","#f7f7f7","#a6dba0","#008837"],
    ["#762a83","#af8dc3","#e7d4e8","#d9f0d3","#7fbf7b","#1b7837"],
    ["#762a83","#af8dc3","#e7d4e8","#f7f7f7","#d9f0d3","#7fbf7b","#1b7837"],
    ["#762a83","#9970ab","#c2a5cf","#e7d4e8","#d9f0d3","#a6dba0","#5aae61","#1b7837"],
    ["#762a83","#9970ab","#c2a5cf","#e7d4e8","#f7f7f7","#d9f0d3","#a6dba0","#5aae61","#1b7837"],
    ["#40004b","#762a83","#9970ab","#c2a5cf","#e7d4e8","#d9f0d3","#a6dba0","#5aae61","#1b7837","#00441b"],
    ["#40004b","#762a83","#9970ab","#c2a5cf","#e7d4e8","#f7f7f7","#d9f0d3","#a6dba0","#5aae61","#1b7837","#00441b"]
    ],
    PiYG: [
    ["#e9a3c9","#f7f7f7","#a1d76a"],
    ["#d01c8b","#f1b6da","#b8e186","#4dac26"],
    ["#d01c8b","#f1b6da","#f7f7f7","#b8e186","#4dac26"],
    ["#c51b7d","#e9a3c9","#fde0ef","#e6f5d0","#a1d76a","#4d9221"],
    ["#c51b7d","#e9a3c9","#fde0ef","#f7f7f7","#e6f5d0","#a1d76a","#4d9221"],
    ["#c51b7d","#de77ae","#f1b6da","#fde0ef","#e6f5d0","#b8e186","#7fbc41","#4d9221"],
    ["#c51b7d","#de77ae","#f1b6da","#fde0ef","#f7f7f7","#e6f5d0","#b8e186","#7fbc41","#4d9221"],
    ["#8e0152","#c51b7d","#de77ae","#f1b6da","#fde0ef","#e6f5d0","#b8e186","#7fbc41","#4d9221","#276419"],
    ["#8e0152","#c51b7d","#de77ae","#f1b6da","#fde0ef","#f7f7f7","#e6f5d0","#b8e186","#7fbc41","#4d9221","#276419"]
    ],
    RdBu: [
    ["#ef8a62","#f7f7f7","#67a9cf"],
    ["#ca0020","#f4a582","#92c5de","#0571b0"],
    ["#ca0020","#f4a582","#f7f7f7","#92c5de","#0571b0"],
    ["#b2182b","#ef8a62","#fddbc7","#d1e5f0","#67a9cf","#2166ac"],
    ["#b2182b","#ef8a62","#fddbc7","#f7f7f7","#d1e5f0","#67a9cf","#2166ac"],
    ["#b2182b","#d6604d","#f4a582","#fddbc7","#d1e5f0","#92c5de","#4393c3","#2166ac"],
    ["#b2182b","#d6604d","#f4a582","#fddbc7","#f7f7f7","#d1e5f0","#92c5de","#4393c3","#2166ac"],
    ["#67001f","#b2182b","#d6604d","#f4a582","#fddbc7","#d1e5f0","#92c5de","#4393c3","#2166ac","#053061"],
    ["#67001f","#b2182b","#d6604d","#f4a582","#fddbc7","#f7f7f7","#d1e5f0","#92c5de","#4393c3","#2166ac","#053061"]
    ],
    RdGy: [
    ["#ef8a62","#ffffff","#999999"],
    ["#ca0020","#f4a582","#bababa","#404040"],
    ["#ca0020","#f4a582","#ffffff","#bababa","#404040"],
    ["#b2182b","#ef8a62","#fddbc7","#e0e0e0","#999999","#4d4d4d"],
    ["#b2182b","#ef8a62","#fddbc7","#ffffff","#e0e0e0","#999999","#4d4d4d"],
    ["#b2182b","#d6604d","#f4a582","#fddbc7","#e0e0e0","#bababa","#878787","#4d4d4d"],
    ["#b2182b","#d6604d","#f4a582","#fddbc7","#ffffff","#e0e0e0","#bababa","#878787","#4d4d4d"],
    ["#67001f","#b2182b","#d6604d","#f4a582","#fddbc7","#e0e0e0","#bababa","#878787","#4d4d4d","#1a1a1a"],
    ["#67001f","#b2182b","#d6604d","#f4a582","#fddbc7","#ffffff","#e0e0e0","#bababa","#878787","#4d4d4d","#1a1a1a"]
    ],
    RdYlBu: [
    ["#fc8d59","#ffffbf","#91bfdb"],
    ["#d7191c","#fdae61","#abd9e9","#2c7bb6"],
    ["#d7191c","#fdae61","#ffffbf","#abd9e9","#2c7bb6"],
    ["#d73027","#fc8d59","#fee090","#e0f3f8","#91bfdb","#4575b4"],
    ["#d73027","#fc8d59","#fee090","#ffffbf","#e0f3f8","#91bfdb","#4575b4"],
    ["#d73027","#f46d43","#fdae61","#fee090","#e0f3f8","#abd9e9","#74add1","#4575b4"],
    ["#d73027","#f46d43","#fdae61","#fee090","#ffffbf","#e0f3f8","#abd9e9","#74add1","#4575b4"],
    ["#a50026","#d73027","#f46d43","#fdae61","#fee090","#e0f3f8","#abd9e9","#74add1","#4575b4","#313695"],
    ["#a50026","#d73027","#f46d43","#fdae61","#fee090","#ffffbf","#e0f3f8","#abd9e9","#74add1","#4575b4","#313695"]
    ],
    Spectral: [
    ["#fc8d59","#ffffbf","#99d594"],
    ["#d7191c","#fdae61","#abdda4","#2b83ba"],
    ["#d7191c","#fdae61","#ffffbf","#abdda4","#2b83ba"],
    ["#d53e4f","#fc8d59","#fee08b","#e6f598","#99d594","#3288bd"],
    ["#d53e4f","#fc8d59","#fee08b","#ffffbf","#e6f598","#99d594","#3288bd"],
    ["#d53e4f","#f46d43","#fdae61","#fee08b","#e6f598","#abdda4","#66c2a5","#3288bd"],
    ["#d53e4f","#f46d43","#fdae61","#fee08b","#ffffbf","#e6f598","#abdda4","#66c2a5","#3288bd"],
    ["#9e0142","#d53e4f","#f46d43","#fdae61","#fee08b","#e6f598","#abdda4","#66c2a5","#3288bd","#5e4fa2"],
    ["#9e0142","#d53e4f","#f46d43","#fdae61","#fee08b","#ffffbf","#e6f598","#abdda4","#66c2a5","#3288bd","#5e4fa2"]
    ],
    RdYlGn: [
    ["#fc8d59","#ffffbf","#91cf60"],
    ["#d7191c","#fdae61","#a6d96a","#1a9641"],
    ["#d7191c","#fdae61","#ffffbf","#a6d96a","#1a9641"],
    ["#d73027","#fc8d59","#fee08b","#d9ef8b","#91cf60","#1a9850"],
    ["#d73027","#fc8d59","#fee08b","#ffffbf","#d9ef8b","#91cf60","#1a9850"],
    ["#d73027","#f46d43","#fdae61","#fee08b","#d9ef8b","#a6d96a","#66bd63","#1a9850"],
    ["#d73027","#f46d43","#fdae61","#fee08b","#ffffbf","#d9ef8b","#a6d96a","#66bd63","#1a9850"],
    ["#a50026","#d73027","#f46d43","#fdae61","#fee08b","#d9ef8b","#a6d96a","#66bd63","#1a9850","#006837"],
    ["#a50026","#d73027","#f46d43","#fdae61","#fee08b","#ffffbf","#d9ef8b","#a6d96a","#66bd63","#1a9850","#006837"]
    ],
    Accent: [
    ["#7fc97f","#beaed4","#fdc086"],
    ["#7fc97f","#beaed4","#fdc086","#ffff99"],
    ["#7fc97f","#beaed4","#fdc086","#ffff99","#386cb0"],
    ["#7fc97f","#beaed4","#fdc086","#ffff99","#386cb0","#f0027f"],
    ["#7fc97f","#beaed4","#fdc086","#ffff99","#386cb0","#f0027f","#bf5b17"],
    ["#7fc97f","#beaed4","#fdc086","#ffff99","#386cb0","#f0027f","#bf5b17","#666666"]
    ],
    Dark: [
    ["#1b9e77","#d95f02","#7570b3"],
    ["#1b9e77","#d95f02","#7570b3","#e7298a"],
    ["#1b9e77","#d95f02","#7570b3","#e7298a","#66a61e"],
    ["#1b9e77","#d95f02","#7570b3","#e7298a","#66a61e","#e6ab02"],
    ["#1b9e77","#d95f02","#7570b3","#e7298a","#66a61e","#e6ab02","#a6761d"],
    ["#1b9e77","#d95f02","#7570b3","#e7298a","#66a61e","#e6ab02","#a6761d","#666666"]
  ],
  Paired: [
    ["#a6cee3","#1f78b4","#b2df8a"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99"],
    ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928"]
  ],
  Pastel1: [
    ["#fbb4ae","#b3cde3","#ccebc5"],
    ["#fbb4ae","#b3cde3","#ccebc5","#decbe4"],
    ["#fbb4ae","#b3cde3","#ccebc5","#decbe4","#fed9a6"],
    ["#fbb4ae","#b3cde3","#ccebc5","#decbe4","#fed9a6","#ffffcc"],
    ["#fbb4ae","#b3cde3","#ccebc5","#decbe4","#fed9a6","#ffffcc","#e5d8bd"],
    ["#fbb4ae","#b3cde3","#ccebc5","#decbe4","#fed9a6","#ffffcc","#e5d8bd","#fddaec"],
    ["#fbb4ae","#b3cde3","#ccebc5","#decbe4","#fed9a6","#ffffcc","#e5d8bd","#fddaec","#f2f2f2"]
  ],
  Pastel2: [
    ["#b3e2cd","#fdcdac","#cbd5e8"],
    ["#b3e2cd","#fdcdac","#cbd5e8","#f4cae4"],
    ["#b3e2cd","#fdcdac","#cbd5e8","#f4cae4","#e6f5c9"],
    ["#b3e2cd","#fdcdac","#cbd5e8","#f4cae4","#e6f5c9","#fff2ae"],
    ["#b3e2cd","#fdcdac","#cbd5e8","#f4cae4","#e6f5c9","#fff2ae","#f1e2cc"],
    ["#b3e2cd","#fdcdac","#cbd5e8","#f4cae4","#e6f5c9","#fff2ae","#f1e2cc","#cccccc"]
  ],
  Set1: [
    ["#e41a1c","#377eb8","#4daf4a"],
    ["#e41a1c","#377eb8","#4daf4a","#984ea3"],
    ["#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00"],
    ["#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00","#ffff33"],
    ["#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628"],
    ["#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628","#f781bf"],
    ["#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628","#f781bf","#999999"]
  ],
  Set2: [
    ["#66c2a5","#fc8d62","#8da0cb"],
    ["#66c2a5","#fc8d62","#8da0cb","#e78ac3"],
    ["#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854"],
    ["#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854","#ffd92f"],
    ["#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854","#ffd92f","#e5c494"],
    ["#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854","#ffd92f","#e5c494","#b3b3b3"]
  ],
  Set3: [
    ["#8dd3c7","#ffffb3","#bebada"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9","#bc80bd"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9","#bc80bd","#ccebc5"],
    ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9","#bc80bd","#ccebc5","#ffed6f"]
  ],
}
