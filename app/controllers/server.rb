module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do
      source = Source.new(identifier: params["identifier"], root_url: params["rootUrl"])
        parsed_source = CreateSource.new(source)
        status parsed_source.status
        body parsed_source.body
    end

    post '/sources/:identifier/data' do |identifier|
      if !params.include?("payload")
        missing_payload
      else
        parsed_params = JSON.parse(params["payload"])
          if Source.where(identifier: identifier) == []
            status 403
            body "Identifier doesn't exist"
          else 
            payload = new_payload(parsed_params, identifier)
            parsed_payload = CreatePayload.new(payload)
            status parsed_payload.status
            body parsed_payload.body
          end
      end
    end
    
    def new_payload(parsed_params, identifier)
      Payload.new(source_id:       Source.find_by(identifier: identifier).id,
                  url_id:          Url.find_or_create_by(address: parsed_params["url"]).id,
                  requested_at:    parsed_params["requestedAt"],
                  responded_in:    parsed_params["respondedIn"],
                  referrer_id:     Referrer.find_or_create_by(referrer_url: parsed_params["referredBy"]).id,
                  request_type_id: RequestType.find_or_create_by(verb_name: parsed_params["requestType"]).id,
                  parameters:      parsed_params["parameters"],
                  event_id:        Event.find_or_create_by(name: parsed_params["eventName"]).id,
                  user_agent_id:   UserAgent.find_or_create_by(browser_info: parsed_params["userAgent"]).id,
                  resolution_id:   Resolution.find_or_create_by(width: parsed_params["resolutionWidth"], height: parsed_params["resolutionHeight"]).id,
                  ip_id:           Ip.find_or_create_by(address: parsed_params["ip"]).id,
                  )
    end
    
    def missing_payload
        status 400
        body "Missing payload"
    end
    
    get '/sources/:identifier' do |identifier|
      @ordered_urls = Source.order_urls(identifier)
      # @browsers = Source.browser_info(identifier)
      # @os = Source.os_info(identifier)
      @resolution_heights = Source.screen_resolution_height(identifier)
      @resolution_widths = Source.screen_resolution_width(identifier)
      
      erb :client_page
    end
  end
end
