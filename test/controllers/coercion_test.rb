require File.expand_path('../../test_helper', __FILE__)

class CoercionsControllerTest < ActionController::TestCase

  ## tests on bad filters
  def test_bad_custom_filter_value_not_integer
    assert_cacheable_get :index, params: {filter: {integer: 'no_way'}}
    assert_response :bad_request
    assert_match /no_way is not a valid value for integer/, response.body
  end

  def test_bad_custom_filter_value_integer_as_nil
    assert_cacheable_get :index, params: {filter: {integer: nil}}
    assert_response :bad_request
    assert_match /is not a valid value for integer/, response.body
  end

  def test_bad_custom_filter_value_integer_as_empty_string
    assert_cacheable_get :index, params: {filter: {integer: ''}}
    assert_response :bad_request
    assert_match /is not a valid value for integer/, response.body
  end

  def test_bad_custom_filter_value_not_boolean
    assert_cacheable_get :index, params: {filter: {boolean: 'no_way'}}
    assert_response :bad_request
    assert_match /no_way is not a valid value for boolean/, response.body
  end

  def test_bad_custom_filter_value_not_float
    assert_cacheable_get :index, params: {filter: {float: 'no_way'}}
    assert_response :bad_request
    assert_match /no_way is not a valid value for float/, response.body
  end

  def test_bad_custom_filter_value_not_date
    assert_cacheable_get :index, params: {filter: {created_at_as_date: 'no_way'}}
    assert_response :bad_request
    assert_match /no_way is not a valid value for created_at/, response.body
  end

  ## tests on good filters
  def test_good_custom_filter_value_integer
    assert_cacheable_get :index, params: {filter: {integer: '1'}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal 1, json_response['data'][0]['attributes']['integer']

    assert_cacheable_get :index, params: {filter: {integer: '3'}}
    assert_response :success
    assert_equal 0, json_response['data'].count
  end

  def test_good_custom_filter_value_boolean
    assert_cacheable_get :index, params: {filter: {boolean: true}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal true, json_response['data'][0]['attributes']['boolean']

    assert_cacheable_get :index, params: {filter: {boolean: 'false'}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal false, json_response['data'][0]['attributes']['boolean']

    assert_cacheable_get :index, params: {filter: {boolean: 'y'}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal true, json_response['data'][0]['attributes']['boolean']
    assert_equal 'string11', json_response['data'][0]['attributes']['string']

    assert_cacheable_get :index, params: {filter: {boolean: '1'}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal true, json_response['data'][0]['attributes']['boolean']
    assert_equal 'string11', json_response['data'][0]['attributes']['string']

    assert_cacheable_get :index, params: {filter: {boolean: 'yes'}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal true, json_response['data'][0]['attributes']['boolean']
    assert_equal 'string11', json_response['data'][0]['attributes']['string']

  end

  def test_good_custom_filter_value_float
    assert_cacheable_get :index, params: {filter: {float: 1.1}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_equal 1.1, json_response['data'][0]['attributes']['float']

    assert_cacheable_get :index, params: {filter: {float: '5.5'}}
    assert_response :success
    assert_equal 0, json_response['data'].count
  end

  def test_good_custom_filter_value_date
    assert_cacheable_get :index, params: {filter: {created_at_as_date: '2016-12-15'}}
    assert_response :success
    # include records from full day
    assert_equal 1, json_response['data'].count

    assert_cacheable_get :index, params: {filter: {created_at_as_date_time: '2016-12-15 12:47:00'}}
    assert_response :success
    assert_equal 1, json_response['data'].count
  end

  def test_empty_filter_string_if_allow_nil
    assert_cacheable_get :index, params: {filter: {string: ''}}
    assert_response :success
    assert_equal 1, json_response['data'].count
    assert_nil json_response['data'][0]['attributes']['string']
  end

end


