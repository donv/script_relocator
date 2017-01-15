require 'minitest/autorun'
require 'minitest/reporters'
require 'script_relocator'

MiniTest::Reporters.use!

class ScriptRelocatorTest < Minitest::Test
  def test_constructor
    result = nil
    sl = ScriptRelocator::Rack.new -> env do
      result = true
      [200, {'Content-Type' => 'text/html'}, ['<html><body>Success</body></html>']]
    end
    sl.call({})
    assert result
  end

  def test_script_is_moved
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, ['<html><head></head><body><script></script>Success</body></html>']]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, ['<html><head></head><body>Success<script></script></body></html>']], result
  end

  def test_script_non_html_content_type_is_not_changed
    sl = ScriptRelocator::Rack.new -> env do
      [200, {}, '<html><body><script></script>Success</body></html>']
    end
    result = sl.call({})
    assert_equal [200, {}, '<html><body><script></script>Success</body></html>'], result
  end

  def test_script_double_quotes_are_preserved
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, [%q{<html><body><tag attr='"'/></html>}]]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, [%q{<html><body><tag attr='"'/></html>}]], result
  end
end
