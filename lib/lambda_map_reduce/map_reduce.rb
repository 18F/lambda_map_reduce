# @author Mike Bland (michael.bland@gsa.gov)

module LambdaMapReduce
  # Returns an Array of objects after mapping and reducing items.
  # mapper takes a single item and returns an Array of [key, value] pairs.
  # reducer takes a [key, Array of values] pair and returns a single item.
  def self.map_reduce(items, mapper, reducer)
    items.flat_map { |item| mapper.call(item) }.compact
      .each_with_object({}) { |kv, shuffle| (shuffle[kv[0]] ||= []) << kv[1] }
      .map { |key, values| reducer.call(key, values) }.compact
  end
end
