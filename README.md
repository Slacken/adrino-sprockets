# Padrino::Sprockets

Sprockets, also known as "the asset pipeline", is a system for pre-processing, compressing and serving up of javascript, css and image assets. `Padrino::Sprockets` provides integration with the Padrino web framework.

## Installation

Install from RubyGems:

```sh
$ gem install padrino-sprockets
```

Or include it in your project's `Gemfile` with Bundler:

```ruby
gem 'my-padrino-sprockets', :require => "padrino/sprockets"
```

## Usage

Place your assets under these paths:

```
app/assets/javascripts
app/assets/images
app/assets/stylesheets
```

Register sprockets in your application when development environment:

```ruby
class Redstore < Padrino::Application
  if Padrino.env == :development
    register Padrino::Sprockets
    sprockets  # :url => 'assets', :root => app.root, :mifiy => true
  end
end
```


In production environment, use the following code in Rakefile to generate precompiled files:

```ruby
desc 'precompile .css & .js manifest files'
task :precompile do
  root = File.dirname(__FILE__)
  e = Padrino::Sprockets::App.new(nil, minify: true, output: root + '/public/', root: root + '/app')
  e.precompile(%w{application.css application.js})
end
```

For more documentation about sprockets, have a look at the [Sprockets](https://github.com/sstephenson/sprockets/) gem.

## Helpers Usage

### sprockets

```ruby
:root =>  'asset root' # default is app.root
:url => 'assets'  # default map url, location, default is 'assets'
```

## Contributors

* [@matthias-guenther](https://github.com/matthias-guenther)
* [@swistak](https://github.com/swistak)
* [@dommmel](https://github.com/dommmel)
* [@charlesvallieres](https://github.com/charlesvallieres)
* [@jfcixmedia](https://github.com/jfcixmedia)
* [@stefl](https://github.com/stefl)
* [@mikesten](https://github.com/mikesten)
