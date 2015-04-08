
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
      source = Source.new(identifier: params["identifier"], root_url: params["rootUrl"])
        parsed_source = CreateSource.new(source)
        status parsed_source.status
        body parsed_source.body
    end

    post '/sources/:identifier/data' do |identifier|

      if !params.has_key?("payload")
        status 400
        body "Missing payload"
      elsif Payload.where(url_id: Url.find_or_create_by(address: params["payload"]["url"]).id,
                                                        requested_at: params["payload"]["requestedAt"],
                                                        user_agent_id: UserAgent.find_or_create_by(browser_info: params["payload"]["userAgent"]).id) == []
         payload = Payload.create(url_id: Url.find_or_create_by(address: params["payload"]["url"]).id,
                               requested_at: params["payload"]["requestedAt"],
                               responded_in: params["payload"]["respondedIn"],
                               referrer_id: Referrer.find_or_create_by(referrer_url: params["payload"]["referredBy"]).id,
                               request_type_id: RequestType.find_or_create_by(verb_name: params["payload"]["requestType"]).id,
                               parameters: params["payload"]["parameters"],
                               event_id: Event.find_or_create_by(name: params["payload"]["eventName"]).id,
                               user_agent_id: UserAgent.find_or_create_by(browser_info: params["payload"]["userAgent"]).id,
                               resolution_size_id: Resolution.find_or_create_by(width: params["payload"]["resolutionWidth"], height: params["payload"]["resolutionHeight"]).id,
                               ip_id: Ip.find_or_create_by(address: params["payload"]["ip"]).id,
                               )
         parsed_payload = CreatePayload.new(payload)
         status parsed_payload.status
         body parsed_payload.body
       else
         status 403
         body "Already received request"
     end
    end


  def new_payload(params)
    Payload.new(url_id: Url.find_or_create_by(address: params["payload"]["url"]).id,
                             requested_at: params["payload"]["requestedAt"],
                             responded_in: params["payload"]["respondedIn"],
                             referrer_id: Referrer.find_or_create_by(referrer_url: params["payload"]["referredBy"]).id,
                             request_type_id: RequestType.find_or_create_by(verb_name: params["payload"]["requestType"]).id,
                             parameters: params["payload"]["parameters"],
                             event_id: Event.find_or_create_by(name: params["payload"]["eventName"]).id,
                             user_agent_id: UserAgent.find_or_create_by(browser_info: params["payload"]["userAgent"]).id,
                             resolution_size_id: Resolution.find_or_create_by(width: params["payload"]["resolutionWidth"], height: params["payload"]["resolutionHeight"]).id,
                             ip_id: Ip.find_or_create_by(address: params["payload"]["ip"]).id,
                             )
                         end
  end
end
