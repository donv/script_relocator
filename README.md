# ScriptRelocator

Rack middleware to relocate JavaScript tags to the end of an HTML response body.
Only handles non-streaming `text/html` reponses.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'script_relocator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install script_relocator

## Usage

The gem will hook into Rails automatically.

For other Rack application use it as middleware:

```ruby
  use ScriptRelocator::Rack
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/script_relocator.
