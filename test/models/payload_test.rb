require './test/test_helper.rb'

class PayloadTest < Minitest::Test
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
  
  def test_payload_assigns_correct_attributes
    assert_equal 4, @source.payloads.first.url_id
    assert_equal "2013-01-13 21:38:28 -0700", @source.payloads.first.requested_at
    assert_equal 37, @source.payloads.first.responded_in
    assert_equal 2, @source.payloads.first.referrer_id
    assert_equal 1, @source.payloads.first.request_type_id
    assert_equal 1, @source.payloads.first.event_id
    assert_equal 1, @source.payloads.first.user_agent_id
    assert_equal 4, @source.payloads.first.resolution_id
    assert_equal 4, @source.payloads.first.ip_id
    assert_equal 1, @source.payloads.first.source_id
  end
end