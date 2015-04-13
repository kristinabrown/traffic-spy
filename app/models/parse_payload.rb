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
        parse_and_check_indentifier_for_status
      end
    end

    def body
      if !@params.include?("payload")
        "Missing payload"
      else
        parse_and_check_indentifier_for_boody
      end
    end

    private

    def new_payload(parsed_params, identifier)
      Payload.new(
      source_id:       find_source_id(parsed_params, identifier),
      url_id:          find_url_id(parsed_params),
      requested_at:    parsed_params["requestedAt"],
      responded_in:    parsed_params["respondedIn"],
      referrer_id:     find_referrer_id(parsed_params),
      request_type_id: find_request_type_id(parsed_params),
      parameters:      parsed_params["parameters"],
      event_id:        find_event_id(parsed_params),
      user_agent_id:   find_user_agent_id(parsed_params),
      resolution_id:   find_resolution_id(parsed_params),
      ip_id:           find_ip_id(parsed_params))
    end

    def find_source_id(parsed_params, identifier)
      Source.find_by(identifier: identifier).id
    end

    def find_url_id(parsed_params)
      Url.find_or_create_by(address:       parsed_params["url"],
                            relative_path: URI(parsed_params["url"]).path).id
    end

    def find_referrer_id(parsed_params)
      Referrer.find_or_create_by(referrer_url: parsed_params["referredBy"]).id
    end

    def find_request_type_id(parsed_params)
      RequestType.find_or_create_by(verb_name: parsed_params["requestType"]).id
    end

    def find_event_id(parsed_params)
      Event.find_or_create_by(name: parsed_params["eventName"]).id
    end

    def find_user_agent_id(parsed_params)
      UserAgent.find_or_create_by(browser_info: parsed_params["userAgent"]).id
    end

    def find_resolution_id(parsed_params)
      Resolution.find_or_create_by(width: parsed_params["resolutionWidth"],
                                  height: parsed_params["resolutionHeight"]).id
    end

    def find_ip_id(parsed_params)
      Ip.find_or_create_by(address: parsed_params["ip"]).id
    end

    def parsed_json_params
      JSON.parse(@params["payload"])
    end

    def parse_and_check_indentifier_for_status
      parsed_params = parsed_json_params
      if Source.where(identifier: @identifier) == []
        403
      else
        create_payload_and_check_if_repeated_status(parsed_params)
      end
    end

    def create_payload_and_check_if_repeated_status(parsed_params)
      pl = new_payload(parsed_params, @identifier)
      if Payload.where(url_id: pl.url_id, requested_at: pl.requested_at,
                      user_agent_id: pl.user_agent_id) == []
        pl.save
        200
      else
        403
      end
    end

    def parse_and_check_indentifier_for_boody
      parsed_params = parsed_json_params
      if Source.where(identifier: @identifier) == []
        "Identifier doesn't exist"
      else
        create_payload_and_check_if_repeated_body(parsed_params)
      end
    end

    def create_payload_and_check_if_repeated_body(parsed_params)
      pl = new_payload(parsed_params, @identifier)
      if  Payload.where(url_id: pl.url_id, requested_at: pl.requested_at,
                        user_agent_id: pl.user_agent_id) == []
        "success"
      else
        "Duplicate payload request"
      end
    end
  end
end