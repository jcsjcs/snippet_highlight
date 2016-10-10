module SnippetHighlight

  # Takes a snippet of code as input and formats it as HTML with inline styles.
  #
  # Using clipboard input and output example:
  #    sniphigh = SnippetHighlight::SnippetHighlight.new('sql', :inline => true)
  #    res = sniphigh.input_from_clipboard
  #    abort res if res
  #    sniphigh.transform
  #    sniphigh.replace_on_clipboard
  #
  # Using String input and output example:
  #    sniphigh = SnippetHighlight::SnippetHighlight.new('sql', :inline => true)
  #    sniphigh.input('SELECT * FROM users;')
  #    sniphigh.transform
  #    puts sniphigh.formatted_output
  #
  class SnippetHighlight
    attr_reader :formatted_output

    # +format+ must be a String denoting the code language to be highlighted.
    # +opts+ are options that affect the output:
    # - :inline : When true, the output will be wrapped in <code>, not <pre>.
    # - :lineno : When true, the output wil lbe in a table with a column of line numbers.
    # - :base16 : When true, the highlighting will use the +base16+ theme instead of the +github+ theme.
    def initialize(format, opts={})
      self.highlight_opts = opts
      self.format         = format
      raise ArgumentError, "Invalid format: \"#{format}\"" unless 'irb' == format || Rouge::Lexer.find(format)
    end

    # Set the +input_string+.
    def input(str)
      @input_string = str
    end

    # Get +input_string+ from the clipboard.
    # Calls <tt>xclip -o</tt> to fetch the String.
    # Returns +nil+ if successful or an error message.
    def input_from_clipboard
      @input_string, error_message, status = Open3.capture3('xclip', '-o')
      status == 0 ? nil : error_message

    rescue Errno::ENOENT
      "\"xclip\" is not installed."
    end

    # Replace the clipboard with the +formatted_string+.
    def replace_on_clipboard
      exit_status = nil
      Open3.popen2e("xclip") {|input, output, thread|
        input << formatted_output
        input.close
        exit_status = thread.value
      }
      exit_status
    end

    # Transform +input_string+ to +formatted_output+.
    def transform
      is_irb = 'irb' == @format
      opts = {:css_class    => nil,
              :inline_theme => @highlight_opts[:base16] ? Rouge::Themes::Base16.new : Rouge::Themes::Github.new,
              :line_numbers => @highlight_opts[:lineno]}

      if is_irb
        make_irb_string(opts)
      else
        make_formatted_string(opts)
      end
    end

    private
    attr_writer :input_string, :formatted_output, :highlight_opts, :format

    def make_irb_string(opts)
      opts[:wrap] = false
      formatter   = Rouge::Formatters::HTMLLegacy.new(opts)
      new         = []

      lexer = Rouge::Lexers::Ruby.new
      @input_string.split("\n").each do |a|
        m = a.match(/^.+?>/)
        b = m.nil? ? '' : m[0]
        c = b =~ /.*=>/ ? '# =>' : ''
        new << (formatter.format(lexer.lex(c << a.sub(b, ''))))
      end
      self.formatted_output = "<pre>#{new.join("\n")}</pre>"
    end

    def make_formatted_string(opts)
      opts[:wrap] = false if @highlight_opts[:inline]
      formatter = Rouge::Formatters::HTMLLegacy.new(opts)
      if @highlight_opts[:inline]
        tag_start = '<code>'
        tag_end = '</code>'
      else
        tag_start = ''
        tag_end = ''
      end
      lexer  = Rouge::Lexer.find(@format)
      self.formatted_output = "#{tag_start}#{formatter.format(lexer.lex(@input_string))}#{tag_end}"
    end
  end

end
