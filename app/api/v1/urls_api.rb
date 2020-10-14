module V1
  class UrlsApi < Grape::API
    format :json

    desc 'returns short url for given url'
    params do
      requires :url, type: String
    end
    get '/' do
      short_url = Base64.strict_encode64(params[:url])

      { short_url: short_url }
    end

    desc 'returns full url for given short url'
    params do
      requires :short_url, type: String
    end
    post '/:short_url' do
      full_url = Base64.decode64(params[:short_url])

      redis_key = "follow_count_#{params[:short_url]}"
      current_count = $redis.get(redis_key)
      $redis.set(redis_key, current_count.to_i + 1)

      { url: full_url }
    end

    desc 'returns short url stats'
    params do
      requires :short_url, type: String
    end
    get '/:short_url/stats' do
      count = $redis.get("follow_count_#{params[:short_url]}")

      { url_follow_count: count }
    end

  end
end
