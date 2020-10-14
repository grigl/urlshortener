require 'test_helper'

class V1::UrlsApiTest < ActionDispatch::IntegrationTest
  test 'post "/" returns short url for given full url' do
    url = 'google.com'
    expected_short_url = 'Z29vZ2xlLmNvbQ=='

    get '/', params: { url: url }

    assert_equal('200', response.code)
    assert_equal({ 'short_url' => expected_short_url }, JSON.parse(response.body))
  end

  test 'get "/:short_url" returns full url for given short url and increments counter' do
    $redis.flushdb

    short_url = 'Z29vZ2xlLmNvbQ=='
    expected_full_url = 'google.com'
    redis_key = "follow_count_#{short_url}"

    post "/#{short_url}"

    assert_equal('201', response.code)
    assert_equal({ 'url' => expected_full_url }, JSON.parse(response.body))
    assert_equal($redis.get(redis_key), '1')
  end

  test 'get "/:short_url/stats" returns follow count for short url' do
    $redis.flushdb

    short_url = 'ZmFjZWJvb2suY29t'
    redis_key = "follow_count_#{short_url}"

    $redis.set(redis_key, '123')

    get "/#{short_url}/stats"

    assert_equal('200', response.code)
    assert_equal({ 'url_follow_count' => '123' }, JSON.parse(response.body))
  end
end
