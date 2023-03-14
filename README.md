# PerfoLab

This framework used to simplify routine operations of benchmarking processes.
We always should run different tools and compare result of our experiments.

This gem provide instrument that run configured profilers and benchmarks
against your code, save results of profiler to own directory and show diff
between current and previous run.

Framework allow to append text report about performance session with diff tables
for future analyze results of entire refactoring.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

```ruby
require 'perfolab'

loop =
  PerfoLab::Loop.new do |config|
    config[:ruby_prof] = {
      track_allocations: true,
      measure_mode: RubyProf::MEMORY
    }
    config[:stackprof] = {
      mode: :object,
      raw: true
    }
    config[:benchmark] = {
      start: 1,
      limit: 32,
      ratio: 2
    }
  end

loop.analyze do |i|
  # `i` - number of [1, 2, 4, 8, 16, 32] for benchmark
  analyzed_code_fragment(i)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/perfolab. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/perfolab/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PerformanceStand project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/perfolab/blob/master/CODE_OF_CONDUCT.md).
