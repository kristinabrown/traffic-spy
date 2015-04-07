# require_relative '../models/create_source'

module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end
    
    post '/sources' do
      source = Source.new(params[:source])
        parsed_source = CreateSource.new(source)
        status parsed_source.status
        body parsed_source.body
    end
  end
end