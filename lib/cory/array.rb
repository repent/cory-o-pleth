#class Array
#  # sizes is an array of sizes of each slice that should be returned
#  # the sum of all sizes must equal the length of the array.
#  #
#  # E.g.
#  # a = 1.upto(10).to_a
#  # => [1,2,3,4,5,6,7,8,9,10]
#  # a.into_slices [ 3, 4, 3 ]
#  # => [ [1,2,3],
#  #      [4,5,6,7],
#  #      [8,9,10]
#  #    ]
#  def into_slices(sizes)
#    raise "Incorrect number of slices" unless self.length == sizes.inject(0, :+)
#    slices = []
#    start = 0
#    sizes.each do |size|
#      slices.push self.slice(start, size)
#      start += size
#    end
#    slices
#  end
#end