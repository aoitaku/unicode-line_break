# unicode-linebreak

A Ruby implementation of the Unicode Line Breaking Algorithm (UAX #14).

> Line breaking, also known as word wrapping, is the process of breaking a section of text into lines such that it will fit in the available width of a page, window or other display area. The Unicode Line Breaking Algorithm performs part of this process. Given an input text, it produces a set of positions called "break opportunities" that are appropriate points to begin a new line. The selection of actual line break positions from the set of break opportunities is not covered by the Unicode Line Breaking Algorithm, but is in the domain of higher level software with knowledge of the available width and the display size of the text.

See [Unicode Standard Annex #14 - UNICODE LINE BREAKING ALGORITHM](http://unicode.org/reports/tr14/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unicode-line_break'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unicode-line_break

## Contributing

1. Fork it ( https://github.com/[my-github-username]/unicode-line_break/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Reference

Implementations in other languages.

### Perl
- [Unicode-LineBreak](https://github.com/hatukanezumi/Unicode-LineBreak/)

### Python
- [uniseg-python](https://bitbucket.org/emptypage/uniseg-python)

### Node.js
- [linebreak](https://github.com/devongovett/linebreak)

## Licence

zlib/libpng
