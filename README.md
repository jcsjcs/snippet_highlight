# SnippetHighlight

Convert a snippet of code into syntax-highlighted HTML.
Although this gem can be used in code, its reason for being is to take a snippet of code on the X-selection clipboard, format it and return the formatted HTML to the clipboard, ready to be pasted into an email message.

A typical use case is to add syntax-highlighted code to an email.

## Requirements

* An OS that uses X. (Tested on Ubuntu).
* xclip. (http://sourceforge.net/projects/xclip/)
* Ruby version > 1.8.

## Installation

Install it as:

    $ gem install snippet_highlight

## Usage

### Using the commandline to copy to clipboard

* Select a snippet of text with the mouse or keyboard.
* Run `sniphigh sql`. Where sql can be any term that Rouge (https://github.com/jneen/rouge) supports or `irb`. Run `sniphigh -h` for a list.
* Use the middle mouse buton to paste the highlighted snippet from the clipboard.

There are several commandline options available:

~~~
  --inline, -i:   Wrap the output in <code> instead of <pre>.
  --base16, -b:   Use the base16 colour theme instead of the github theme.
  --lineno, -l:   Print line numbers. Not compatible with --inline.
   --print, -p:   Print the output to the commandline instead of copying to clipboard.
~~~

### Using in code

~~~{ruby}
sniphigh  = SnippetHighlight::SnippetHighlight.new('sql')
sniphigh.input('SELECT * FROM users;')
sniphigh.transform
puts sniphigh.formatted_output
# => <pre><code><span style="color: #000000;font-weight: bold">SELECT</span> <span style="color: #000000;font-weight: bold">*</span> <span style="color: #000000;font-weight: bold">FROM</span> <span style="background-color: #f8f8f8">users</span><span style="background-color: #f8f8f8">;</span></code></pre>
~~~

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/jcsjcs/snippet_highlight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
