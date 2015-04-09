module TrafficSpy
  class ParsePayload
    def initialize(params, identifier)
      @params = params
      @identifier = identifier
    end
  
    def status
      if !@params.include?("payload")
        400
      else
        parsed_params = JSON.parse(@params["payload"])
        if Source.where(identifier: @identifier) == []
          403
        else
        payload = new_payload(parsed_params, @identifier)
          if Payload.where(url_id: payload.url_id, requested_at: payload.requested_at, user_agent_id: payload.user_agent_id) == [] 
            payload.save
            200
          else
            403
          end
        end
      end
    end

    def body
      if !@params.include?("payload")
        "Missing payload"
      else
        parsed_params = JSON.parse(@params["payload"])
        if Source.where(identifier: @identifier) == []
          "Identifier doesn't exist"
        else
        payload = new_payload(parsed_params, @identifier)
          if  Payload.where(url_id: payload.url_id, requested_at: payload.requested_at, user_agent_id: payload.user_agent_id) == [] 
            "success"
          else
            "Duplicate payload request"
          end
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
  end
end
