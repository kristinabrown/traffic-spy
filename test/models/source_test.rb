require './test/test_helper.rb'

class SourceTest < Minitest::Test
  include Rack::Test::Methods
  
  def app
    TrafficSpy::Server
  end
  
  def setup
    DatabaseCleaner.start
    
    TestData.clients.each do |params|
      Source.create(identifier: params["identifier"], root_url: params["rootUrl"])
    end
    TestData.payloads.each do |params|
      Payload.create(source_id: params["source_id"], 
                      url_id: Url.find_or_create_by(address: params["url"]).id,
                      requested_at: params["requestedAt"],
                      responded_in: params["respondedIn"],
                      referrer_id: Referrer.find_or_create_by(referrer_url: params["referredBy"]).id,
                      request_type_id: RequestType.find_or_create_by(verb_name: params["requestType"]).id,
                      parameters: params["parameters"],
                      event_id: Event.find_or_create_by(name: params["eventName"]).id,
                      user_agent_id: UserAgent.find_or_create_by(browser_info: params["userAgent"]).id,
                      resolution_size_id: Resolution.find_or_create_by(width: params["resolutionWidth"], height: params["resolutionHeight"]).id,
                      ip_id: Ip.find_or_create_by(address: params["ip"]).id,
                            )
    end
  end
  
  def teardown
    DatabaseCleaner.clean
  end
  
  def test_it_can_find_its_most_requested_url
    get "/sources/yahoo"
    
    assert_equal ["http://yahoo.com/weather", "http://yahoo.com/news"], Source.order_urls("yahoo")
  end
end