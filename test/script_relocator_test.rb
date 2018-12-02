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
      [200, {'Content-Type' => 'text/html'}, ['<!DOCTYPE html><html><head></head><body><script></script>Success</body></html>']]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, ["<!DOCTYPE html>\n<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body>Success<script></script></body></html>\n"]], result
  end

  def test_fragments_are_preserved
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, ['<script></script><span>Fragment</span>']]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, ['<script></script><span>Fragment</span>']], result
  end

  def test_script_non_html_content_type_is_not_changed
    sl = ScriptRelocator::Rack.new -> env do
      [200, {}, '<html><body><script></script>Success</body></html>']
    end
    result = sl.call({})
    assert_equal [200, {}, '<html><body><script></script>Success</body></html>'], result
  end

  def test_double_quotes_are_preserved
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, [%q{<html><body><tag attr='"'/></body></html>}]]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, [%q{<html><body><tag attr='"'/></body></html>}]], result
  end

  def test_unicode_chars_are_preserved_in_document
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, [%q{<!DOCTYPE html><html><body><script/><span>×</span></body></html>}]]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, [%Q{<!DOCTYPE html>\n<html><body><span>×</span><script></script></body></html>\n}]], result
  end

  def test_unicode_chars_are_preserved
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, [%q{<!DOCTYPE html><html><body><script/><span>×</span></body></html>}]]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, [%Q{<!DOCTYPE html>\n<html><body><span>×</span><script></script></body></html>\n}]], result
  end

  def test_entities_are_preserved
    sl = ScriptRelocator::Rack.new -> env do
      [200, {'Content-Type' => 'text/html'}, [%q{<!DOCTYPE html><html><body><script/><span>&times;</span></body></html>}]]
    end
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, [%Q{<!DOCTYPE html>\n<html><body><span>×</span><script></script></body></html>\n}]], result
  end

  def test_ampersands_are_preserved
     html = %q{<!DOCTYPE html>
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head><body><script>
  function checkOtherOption(e, tf) {
    var other_selected = ($(e).val() && ($(e).val().indexOf('annet') > -1));
    tf.prop('disabled', !other_selected);
    if (other_selected) {
        tf.show().focus()
    } else {
        tf.hide()
    }
  }
</script></body></html>
}
    sl = ScriptRelocator::Rack.new -> env { [200, { 'Content-Type' => 'text/html' }, [html]] }
    result = sl.call({})
    assert_equal [200, {'Content-Type' => 'text/html'}, [html]], result
  end
end
