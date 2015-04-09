require './test/test_helper.rb'

class SourceTest < Minitest::Test
  def setup
    DatabaseCleaner.start
  
    @source = TrafficSpy::Source.create(identifier: "yahoo", root_url: "http://yahoo.com")

    TestData.payloads.each do |params|
      TrafficSpy::Payload.create(source_id: params["source_id"], 
                      url_id: TrafficSpy::Url.find_or_create_by(address: params["url"]).id,
                      requested_at: params["requestedAt"],
                      responded_in: params["respondedIn"],
                      referrer_id: TrafficSpy::Referrer.find_or_create_by(referrer_url: params["referredBy"]).id,
                      request_type_id: TrafficSpy::RequestType.find_or_create_by(verb_name: params["requestType"]).id,
                      parameters: params["parameters"],
                      event_id: TrafficSpy::Event.find_or_create_by(name: params["eventName"]).id,
                      user_agent_id: TrafficSpy::UserAgent.find_or_create_by(browser_info: params["userAgent"]).id,
                      resolution_id: TrafficSpy::Resolution.find_or_create_by(width: params["resolutionWidth"], height: params["resolutionHeight"]).id,
                      ip_id: TrafficSpy::Ip.find_or_create_by(address: params["ip"]).id,
                            )
    end
  end
  
  def teardown
    DatabaseCleaner.clean
  end
  
  #   def test_source_assigns_correct_attributes
  #     source = Source.create(identifier: "soemthing", root_url: "something else")
  #     assert_equal "something", source.identifer
  #     assert_equal "something else", source.root_url
  #   end
  #   
  #   def test_source_has_payloads
  #     # create source
  #     assert_equal [], source.payloads
  #   end
  
  def test_it_can_find_its_most_requested_url
    assert_equal ["http://yahoo.com/weather", "http://yahoo.com/news"], @source.ordered_urls
  end
  
  def test_it_can_find_its_user_agent_info    
    assert_equal "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", @source.user_agent_info.first
  end
  
  def test_it_can_find_its_browser_info
    assert_equal "Chrome", @source.browser_info.first
  end
  
  def test_it_can_find_its_os_info
    assert_equal "Macintosh%3B Intel Mac OS X 10_8_2", @source.os_info.first
  end
  
  def test_it_can_find_its_resolution_height
    assert_equal ["800X600", "500X700", "800X600", "800X600", "800X600"], @source.screen_resolution_width_height
  end
end