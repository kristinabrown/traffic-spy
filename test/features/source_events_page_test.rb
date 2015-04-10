require './test/test_helper'

class EventsPagetest < MiniTest::Test
  include Capybara::DSL
  
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
  
  def test_events_links_to_each_event
    visit '/sources/yahoo/events'
    
    assert_equal '/sources/yahoo/events', current_path
    assert page.has_content?("yahoo")
    
    click_link "socialLogin"

    assert_equal '/sources/yahoo/events/socialLogin', current_path
    assert page.has_content?("socialLogin")
  end
end