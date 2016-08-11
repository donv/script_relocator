require 'minitest/autorun'
require 'minitest/reporters'
require 'script_relocator'

MiniTest::Reporters.use!

class ScriptRelocatorTest < Minitest::Test
  def test_constructor
    result = nil
    sl = ScriptRelocator::Rack.new -> env do
      result = true
      [200, {}, '<html><body>Success</body></html>']
    end
    sl.call({})
    assert result
  end
end
