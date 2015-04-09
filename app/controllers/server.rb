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
      
      erb :client_page
    end
    
    get '/sources/:identifier/urls/:relative' do |identifier, relative|
      byebug
      @url = Source.find_by(identifier: identifier).payloads.where()
      @identifier = identifier
      
      erb :url_info
    end
  end
end
