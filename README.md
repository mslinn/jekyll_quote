# `jekyll_quote` [![Gem Version](https://badge.fury.io/rb/jekyll_quote.svg)](https://badge.fury.io/rb/jekyll_quote)

`jekyll_quote` is a Jekyll plugin that displays formatted quotes.

See [demo/index.html](demo/index.html) for examples.


## Installation

Add the following line to your Jekyll project's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_quote'
end
```

And then execute:

```shell
$ bundle
```


## Syntax

```html
{% quote OPTIONS %}
  Content of quote goes here.
{% endquote %}
```

The default preposition is 'From'.

OPTIONS are:

* `break` &ndash; Put the citation on a separate line. Ignored if `cite` was not specified.
* `by` &ndash; Preface the citation with the preposition 'By'. Ignored if `cite` was not specified.
* `cite` &ndash; Citation text
* `class` &ndash; Apply additional CSS classes
* `noprep` &ndash; Do not preface the citation with a preposition. Ignored if `cite` was not specified.
* `style` &ndash; Apply additional CSS styling
* `url` &ndash; URL for the citation. Ignored if `cite` was not specified.


## Usage Example

```html
{% quote cite="Blaise Pascal, in Lettres provinciales"
   url="https://en.wikipedia.org/wiki/Lettres_provinciales"
%}
  I have only made this letter longer because
  I have not had the time to make it shorter.
{% endquote %}
```


## Attribution

See [`jekyll_plugin_support` for `attribution`](https://github.com/mslinn/jekyll_plugin_support#subclass-attribution)


## Demo

A demo / test website is provided in the `demo` directory.
It can be used to debug the plugin or to run freely.
Please examine the HTML files in the demo to see how the plugin works.

To run the demo freely from the command line, type:

```shell
$ demo/_bin/debug -r
```

## Additional Information

More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html).


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


To build and install this gem onto your local machine, run:

```shell
$ bundle exec rake install
jekyll_quote 0.1.0 built to pkg/jekyll_quote-0.1.0.gem.
jekyll_quote (0.1.0) installed.
```

Examine the newly built gem:

```shell
$ gem info jekyll_quote

*** LOCAL GEMS ***

jekyll_quote (0.1.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/jekyll_quote
    License: MIT
    Installed at: /home/mslinn/.gems

    Generates Jekyll logger with colored output.
```


### Running the Demo

Examine the output by running:

```shell
$ demo/_bin/debug -r
```

... and pointing your web browser to http://localhost:4444/


### Unit Tests

Either run `rspec` from Visual Studio Code's *Run and Debug* environment
(<kbd>Ctrl</kbd>-<kbd>shift</kbd>-<kbd>D</kbd>) and view the *Debug Console* output,
or run it from the command line:

```shell
$ rspec
```


### Build and Push to RubyGems

To release a new version,

  1. Update the version number in `version.rb`.
  2. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
  3. Run the following:

     ```shell
     $ bundle exec rake release
     ```

     The above creates a git tag for the version, commits the created tag,
     and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).


## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
