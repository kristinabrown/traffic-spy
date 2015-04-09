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
                      resolution_id: Resolution.find_or_create_by(width: params["resolutionWidth"], height: params["resolutionHeight"]).id,
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
  
  def test_it_can_find_its_user_agent_info
    get "/sources/yahoo"
    
    assert_equal "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", Source.user_agent_info("yahoo").first
  end
  
  def test_it_can_find_its_browser_info
    skip
    get "/sources/yahoo"
    
    assert_equal "Chrome/24.0.1309.0 Safari/537.17", Source.browser_info("yahoo").first
  end
  
  def test_it_can_find_its_os_info
    skip
    get "/sources/yahoo"
    
    assert_equal "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2)", Source.os_info("yahoo").first
  end
  
  def test_it_can_find_its_resolution_height
    get "/sources/yahoo"
    
    assert_equal ["600", "700", "600", "600", "600"], Source.screen_resolution_height("yahoo")
  end
  
  def test_it_can_find_its_resolution_width
    get "/sources/yahoo"
    
    assert_equal ["800", "500", "800", "800", "800"], Source.screen_resolution_width("yahoo")
  end
end