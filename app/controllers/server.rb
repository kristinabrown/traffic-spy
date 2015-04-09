module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do 
        parsed_source = ParseSource.new(params)
        status parsed_source.status
        body parsed_source.body
    end

    post '/sources/:identifier/data' do |identifier|
      parsed_payload = ParsePayload.new(params, identifier)
      status parsed_payload.status
      body parsed_payload.body
    end
    
    get '/sources/:identifier' do |identifier|
      @source = Source.find_by(identifier: identifier)
      #pass @source to view and call methods there
      # @ordered_urls = Source.order_urls(identifier)
      # @browsers = Source.browser_info(identifier)
      # @os = Source.os_info(identifier)
      # @resolution_heights = Source.screen_resolution_width_height(identifier)
      
      erb :client_page
    end
  end
end
