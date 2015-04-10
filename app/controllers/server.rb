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
    
    #ask if we should pull these if/else things out
    get '/sources/:identifier' do |identifier|
      @source = Source.find_by(identifier: identifier)
      if @source.nil?
        erb :identifier_error
      else
        erb :client_page
      end
    end
    
    get '/sources/:identifier/urls/:relative' do |identifier, relative|
      slash_relative = "/#{relative}"
      @url = Url.find_by(relative_path: slash_relative)
      @identifier = identifier
      if @url.nil?
        erb :url_error
      else
        erb :url_info
      end
    end
    
    get '/sources/:identifier/events/:eventname' do |identifier, eventname|
      @event = Event.find_by(name: eventname)
      @identifier = identifier
      if @event.nil?
        erb :event_error
      else
        erb :event
      end
    end
    
    get '/sources/:identifier/events' do |identifier|
      @source = Source.find_by(identifier: identifier)
      if @source.payloads == []
        erb :events_error
      else
        erb :events
      end
    end
  end
end
