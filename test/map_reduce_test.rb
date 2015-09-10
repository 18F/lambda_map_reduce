# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'test_helper'
require_relative '../lib/lambda_map_reduce'

require 'minitest/autorun'

module LambdaMapReduce
  class MapReduceTest < ::Minitest::Test
    MAP_TO_LENGTH = ->(item) { [[item.size, item]] }
    REDUCE_COUNTS = ->(key, values) { [key, values.size] }
    ITEMS = %w(foo bar baz quux xyzzy plugh)

    def test_empty_items_empty_lambdas
      assert_empty LambdaMapReduce.map_reduce([], ->() {}, ->() {})
    end

    def test_empty_items
      assert_empty LambdaMapReduce.map_reduce([], MAP_TO_LENGTH, REDUCE_COUNTS)
    end

    def test_single_item
      assert_equal([[3, 1]],
        LambdaMapReduce.map_reduce(['foo'], MAP_TO_LENGTH, REDUCE_COUNTS))
    end

    def test_multiple_items
      assert_equal([[3, 3], [4, 1], [5, 2]],
        LambdaMapReduce.map_reduce(ITEMS, MAP_TO_LENGTH, REDUCE_COUNTS).sort)
    end

    def test_mapper_emits_a_nil_element
      mapper_with_nil = ->(item) { [[item.size, item]] unless item.size == 4 }
      assert_equal([[3, 3], [5, 2]],
        LambdaMapReduce.map_reduce(ITEMS, mapper_with_nil, REDUCE_COUNTS).sort)
    end

    def test_reducer_emits_a_nil_element
      reducer_with_nil = lambda do |key, values|
        [key, values.size] unless values.size == 3
      end
      assert_equal([[4, 1], [5, 2]],
        LambdaMapReduce.map_reduce(ITEMS, MAP_TO_LENGTH, reducer_with_nil).sort)
    end

    DEVELOPERS = [
      { 'name' => 'mbland', 'languages' => %w(Python Ruby JavaScript Go) },
      { 'name' => 'afeld', 'languages' => %w(Ruby JavaScript) },
      { 'name' => 'arowla', 'languages' => %w(Python JavaScript) },
      { 'name' => 'not_a_dev' },
    ]

    DEV_TO_LANGS = lambda do |developer|
      languages = developer['languages']
      languages.map { |language| [language, developer['name']] } if languages
    end

    # This builds a string to demonstrate that the reducer doesn't just pass
    # its arguments through, although it could if the problem called for it.
    LANGS_BY_NUM_DEVS = lambda do |language, names|
      num_devs = names.size
      "#{language}: used by #{num_devs} developer#{num_devs != 1 ? 's' : ''}"
    end

    def test_mapper_emits_multiple_values
      result = LambdaMapReduce.map_reduce(
        DEVELOPERS, DEV_TO_LANGS, LANGS_BY_NUM_DEVS)
      assert_equal(
        'Go: used by 1 developer\n' \
        'JavaScript: used by 3 developers\n' \
        'Python: used by 2 developers\n' \
        'Ruby: used by 2 developers',
        result.sort.join('\n'))
    end
  end
end
