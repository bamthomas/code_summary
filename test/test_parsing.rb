require "code_summary"
require "test/unit"

class TestParser < Test::Unit::TestCase
  def setup
    @java_parser = JavaParser.new
  end

	def test_empty_line
    assert_equal("", @java_parser.parse_line(""))
    assert_equal("", @java_parser.parse_line("  \t  "))
  end

  def test_line_of_code
    assert_equal(".", @java_parser.parse_line("\tthis is a line of code;"))
    assert_equal(".", @java_parser.parse_line("     this is also a line of code   "))
    end

  def test_line_of_code_with_braces
    assert_equal("{", @java_parser.parse_line("class MyClass {"))
    assert_equal("}", @java_parser.parse_line("    }   // end of bloc"))
  end

  def test_line_of_code_with_double_slash
    assert_equal("", @java_parser.parse_line("   // this is a comment  "))
  end

  def test_line_of_comment_or_javadoc
    assert_equal("", @java_parser.parse_line("   /* this is comment  "))
    assert (@java_parser.is_in_comment)
    assert_equal("", @java_parser.parse_line(" this is comment again "))
    assert_equal("", @java_parser.parse_line(" this is end of comment */ "))
    assert (! @java_parser.is_in_comment)
  end

  def test_imports_and_package_not_counted
    assert_equal("", @java_parser.parse_line("import java.util.date;"))
    assert_equal("", @java_parser.parse_line("package my.package;"))
  end

end
