require './test/test_helper'

class RequestSubmissionTest < MiniTest::Test
  include Rack::Test::Methods
  
  def app
    TrafficSpy::Server
  end

  def test_a_request_can_be_submitted_with_all_fields
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    s = Source.last
  
    assert_equal "jumpstartlab", s.identifier
    assert_equal "http://jumpstartlab.com", s.root_url
    
    assert_equal 200, last_response.status
    assert_equal "{'identifier':'jumpstartlab'}", last_response.body
  end
  
  def test_400_error_when_identifier_is_empty
    original_count = Source.count
    post '/sources', 'rootUrl=http://jumpstartlab.com'
    
    assert_equal original_count, Source.count
    
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end
  
  def test_400_error_when_root_url_is_empty
    original_count = Source.count
    post '/sources', 'identifier=jumpstartlab'
    
    assert_equal original_count, Source.count
    
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end
  
  def test_403_error_when_the_identifier_already_exists
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    original_count = Source.count
    post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    
    assert_equal original_count, Source.count
    
    assert_equal 403, last_response.status
    assert_equal "Identifier has already been taken", last_response.body
  end
end