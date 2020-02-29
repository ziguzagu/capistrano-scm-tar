# capistrano-scm-tar

[![Gem Version](https://badge.fury.io/rb/capistrano-scm-tar.svg)](https://badge.fury.io/rb/capistrano-scm-tar)
[![Maintainability](https://api.codeclimate.com/v1/badges/0c077beb6ef93cd84d3e/maintainability)](https://codeclimate.com/github/ziguzagu/capistrano-scm-tar/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0c077beb6ef93cd84d3e/test_coverage)](https://codeclimate.com/github/ziguzagu/capistrano-scm-tar/test_coverage)

A tar strategy for Capistrano 3 to deploy tarball.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-scm-tar'
```

## Usage

Set `tar` as `scm` option in your `config/deploy.rb`:

```ruby
set :scm, :tar
```

Build a release package of your project and upload it to the server you run capistrano:

```shell
tar czf /tmp/v1.0.0.tar.gz *
scp /tmp/v1.0.0.tar.gz example.com:/tmp/v1.0.0.tar.gz
```

And then, deploy it:

```shell
cap deploy package=/tmp/v1.0.0.tar.gz
```

The basename of tarball is used for the revision number of capistrano setting by `set_current_revision`.


## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/toreta/time_second](https://github.com/toreta/time_second).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
