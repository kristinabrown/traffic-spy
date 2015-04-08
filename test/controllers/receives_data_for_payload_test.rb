require './test/test_helper'

class ReceivesPayloadDataTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_it_can_receive_and_save_payload_data
    post '/sources/:identifier/data', { payload: {
                url:"http://jumpstartlab.com/blog",
                requestedAt:"2013-02-16 21:38:28 -0700",
                respondedIn:37,
                referredBy:"http://jumpstartlab.com",
                requestType:"GET",
                parameters:[],
                eventName: "socialLogin",
                userAgent:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                resolutionWidth:"1920",
                resolutionHeight:"1280",
                ip:"63.29.38.211"
                }}

    payload = Payload.last

    assert_equal 1, Payload.count
    assert_equal 1, payload.url_id
    assert_equal 1, payload.event_id
    assert_equal 1, payload.referrer_id
    assert_equal 1, payload.user_agent_id
    assert_equal 1, payload.request_type_id
    assert_equal 1, payload.ip_id
    assert_equal 200, last_response.status
  end

  def test_missing_payload_gives_400_error
skip
    original_count = Payload.count
    post '/sources/:identifier/data', {}
    #then also test for nothing

    assert_equal original_count, Payload.count

    assert_equal 400, last_response.status
    assert_equal "Missing payload", last_response.body
  end

  def test_duplicate_request_returns_403_error
    post '/sources/:identifier/data', { payload: {
                url:"http://jumpstartlab.com/blog",
                requestedAt:"2013-02-16 21:38:28 -0700",
                respondedIn:37,
                referredBy:"http://jumpstartlab.com",
                requestType:"GET",
                parameters:[],
                eventName: "socialLogin",
                userAgent:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                resolutionWidth:"1920",
                resolutionHeight:"1280",
                ip:"63.29.38.211"
                }}
    original_count = Payload.count

    post '/sources/:identifier/data', { payload: {
                url:"http://jumpstartlab.com/blog",
                requestedAt:"2013-02-16 21:38:28 -0700",
                respondedIn:37,
                referredBy:"http://jumpstartlab.com",
                requestType:"GET",
                parameters:[],
                eventName: "socialLogin",
                userAgent:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                resolutionWidth:"1920",
                resolutionHeight:"1280",
                ip:"63.29.38.211"
                }}

      assert_equal original_count, Payload.count
      assert_equal 403, last_response.status
      assert_equal "Already received request", last_response.body
  end

  def test_application_not_registered_returns_403_error
    skip
  end


end
