# capistrano-scm-tar

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

## License

The MIT License (MIT)
