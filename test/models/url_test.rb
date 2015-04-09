require './test/test_helper.rb'

class SourceTest < Minitest::Test
  def setup
    DatabaseCleaner.start
  
    @source = TrafficSpy::Source.create(identifier: "yahoo", root_url: "http://yahoo.com")

    TestData.payloads.each do |params|
      TrafficSpy::Payload.create(source_id: params["source_id"], 
                      url_id: TrafficSpy::Url.find_or_create_by(address: params["url"], relative_path: URI(params["url"]).path).id,
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
  
  def test_it_has_its_attributes
    assert_equal "http://yahoo.com/weather", @source.payloads.first.url.address
    assert_equal "/weather", @source.payloads.first.url.relative_path
  end
  
  def test_it_can_find_its_average_response_time
    assert_equal 91, @source.payloads.first.url.average_response_time
  end
  
  def test_it_can_find_its_longest_response_time
    assert_equal 200, @source.payloads.first.url.longest_response_time
  end
  
  def test_it_can_find_its_shortest_response_time
    assert_equal 37, @source.payloads.first.url.shortest_response_time
  end
  
  def test_it_can_find_which_HTTP_verbs_are_used
    assert_equal ["GET", "GET", "GET"], @source.payloads.first.url.verbs
  end
  
  def test_it_can_find_most_popular_referrers
    assert_equal ["http://jumpstartlab.com:2", "http://apple.com:1"], @source.payloads.first.url.most_popular_referrers
  end
  
  def test_it_can_find_most_popular_user_agents
    assert_equal ["Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17: 2", "Mozilla/5.0 (Windows%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17: 1"], @source.payloads.first.url.most_popular_user_agents
  end
end