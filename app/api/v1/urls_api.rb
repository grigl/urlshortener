module V1
  class UrlsAPI < Grape::API
    format :json
    
    namespace :urls do

      desc 'returns short url for given url'
      params do
        requires :url, type: String
      end
      post '/' do
      end

      desc 'returns full url for given short url'
      params do
        requires :short_url, type: String
      end
      get '/:short_url' do
      end

      desc 'returns short url stats'
      params do
        requires :short_url, type: String
      end
      get '/:short_url/stats' do
      end

    end
  end
end
