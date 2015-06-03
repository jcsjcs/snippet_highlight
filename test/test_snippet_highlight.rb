require 'minitest_helper'

class TestSnippetHighlight < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SnippetHighlight::VERSION
  end

  def test_it_validates_format
    assert_raises(ArgumentError) {SnippetHighlight::SnippetHighlight.new('non-existent')}
    assert SnippetHighlight::SnippetHighlight.new('sql')
  end

  def test_it_transforms
    test_str  = 'SELECT * FROM users;'
    opts      = {:css_class    => nil, :inline_theme => 'github'}
    formatter = Rouge::Formatters::HTML.new(opts)
    lexer     = Rouge::Lexers::SQL.new
    expect    = formatter.format(lexer.lex(test_str))
    sniphigh  = SnippetHighlight::SnippetHighlight.new('sql')
    sniphigh.input('SELECT * FROM users;')
    sniphigh.transform
    assert_equal expect, sniphigh.formatted_output
  end

  def test_it_manages_irb
    sniphigh  = SnippetHighlight::SnippetHighlight.new('irb')
    sniphigh.input(<<-EOS)
    > 1 + 2
    => 3
    EOS
    sniphigh.transform
    assert_match '=&gt;', sniphigh.formatted_output
  end

  def test_it_uses_themes
    sniphigh1  = SnippetHighlight::SnippetHighlight.new('sql')
    sniphigh1.input('SELECT * FROM users;')
    sniphigh1.transform
    sniphigh2  = SnippetHighlight::SnippetHighlight.new('sql', :base16 => true)
    sniphigh2.input('SELECT * FROM users;')
    sniphigh2.transform
    refute_equal sniphigh1.formatted_output, sniphigh2.formatted_output
  end

  def test_it_has_line_numbers
    sniphigh  = SnippetHighlight::SnippetHighlight.new('sql', :lineno => true)
    sniphigh.input('SELECT * FROM users;')
    sniphigh.transform
    assert_match '<table', sniphigh.formatted_output
  end

  def test_it_produces_inline_output
    sniphigh  = SnippetHighlight::SnippetHighlight.new('sql', :inline => true)
    sniphigh.input('SELECT * FROM users;')
    sniphigh.transform
    assert(/^<code/ =~ sniphigh.formatted_output)
  end

  def test_it_defaults_to_multiline_output
    sniphigh  = SnippetHighlight::SnippetHighlight.new('sql')
    sniphigh.input('SELECT * FROM users;')
    sniphigh.transform
    assert (/^<pre/ =~ sniphigh.formatted_output)
  end

end
