# `lambda_map_reduce` gem

A [MapReduce](https://research.google.com/archive/mapreduce.html)
implementation for use with
[lambdas](http://rubymonk.com/learning/books/1-ruby-primer/chapters/34-lambdas-and-blocks-in-ruby/lessons/77-lambdas-in-ruby).

## Installation

Run `gem install lambda_map_reduce` on the command line or add `gem
'lambda_map_reduce'` to your project's
[`Gemfile`](http://bundler.io/gemfile.html).

## Usage

`LambdaMapReduce.map_reduce` takes an `Enumerable`, a `mapper` lambda, and a
`reducer` lambda.

The `mapper` lambda is called once for every item in the `Enumerable`. It
should take a single item and return an `Array` of `[key, value]` pairs.

The algorithm will shuffle all `value` items with the same `key` together, and
pass the resulting `[key, Array of values] Arrays` to the `reducer`, which
should return a single item.

The `mapper` and `reducer` may return `nil`. The result of the algorithm is
the `Array` of items produced from each `reducer` call.

An example from [the `team_api` gem's `CrossReferencer`
class](https://github.com/18F/team_api/blob/master/lib/team_api/cross_referencer.rb):

```ruby
require 'lambda_map_reduce'

module TeamApi
  class CrossReferencer
    def self.create_tag_xrefs(site, items, category, xref_data)
      items_to_tags = lambda do |item|
        item_xref = xref_data.item_to_xref item
        item[category].map { |tag| [tag, item_xref] } unless item[category].nil?
      end
      create_tag_xrefs = lambda do |tag, item_xrefs|
        [tag, tag_xref(site, category, tag, item_xrefs)]
      end
      LambdaMapReduce.map_reduce(items, items_to_tags, create_tag_xrefs).to_h
    end
  end
end
```

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0
>dedication. By submitting a pull request, you are agreeing to comply
>with this waiver of copyright interest.
