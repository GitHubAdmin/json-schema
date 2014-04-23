require 'test/unit'
require 'active_support'
require 'active_support/core_ext/object/blank'
require File.dirname(__FILE__) + '/../lib/json-schema'

class ModelValidatorTest < Test::Unit::TestCase

  def test_process_required_if
    v = JSON::ModelValidator.new({})
    responses = OpenStruct.new({ a: 'thing' })
    
    error = v.send(:process_required_if, responses, 'b', 'r.a == "something"')
    assert(error.nil?, "should be no errors")

    error = v.send(:process_required_if, responses, 'b', 'r.a == "thing"')
    assert(error == { property: :b, failure: :required }, "should have been an error")

    responses.b = 'is set'
    error = v.send(:process_required_if, responses, 'b', 'r.a == "thing"')
    assert(error.nil?, "should be no errors")
  end

  def test_process_none_of_the_above
    v = JSON::ModelValidator.new({})
    responses = OpenStruct.new({ })

    error = v.send(:process_none_of_the_above, responses, 'a', '7')
    assert(error.nil?, "should be no errors")

    responses.a = 'thing'
    error = v.send(:process_none_of_the_above, responses, 'a', '7')
    assert(error.nil?, "should be no errors")

    responses.a = []
    error = v.send(:process_none_of_the_above, responses, 'a', '7')
    assert(error.nil?, "should be no errors")

    responses.a = [ '1' ]
    error = v.send(:process_none_of_the_above, responses, 'a', '7')
    assert(error.nil?, "should be no errors")

    responses.a = [ '7' ]
    error = v.send(:process_none_of_the_above, responses, 'a', '7')
    assert(error.nil?, "should be no errors")

    responses.a = [ '1', '7' ]
    error = v.send(:process_none_of_the_above, responses, 'a', '7')
    assert(error == { property: :a, failure: :noneOfTheAbove }, "should have been an error")

  end

end
