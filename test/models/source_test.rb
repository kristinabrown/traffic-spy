require './test/test_helper.rb'

class SourceTest < Minitest::Test
  def setup
    DatabaseCleaner.start
  
    @source = TrafficSpy::Source.create(identifier: "yahoo", root_url: "http://yahoo.com")
  end
  
  def teardown
    DatabaseCleaner.clean
  end
  
  def test_source_assigns_correct_attributes
    assert_equal "yahoo", @source.identifier
    assert_equal "http://yahoo.com", @source.root_url
  end
  
  def test_source_has_payloads
    assert_equal 5, @source.payloads.count
  end
  
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
  
  def test_it_can_order_its_url_response_times
    assert_equal ["http://yahoo.com/news: 123", "http://yahoo.com/weather: 91"], @source.ordered_url_response_times
  end
  
  def test_it_can_order_its_events
    assert_equal ["beginRegistration", "socialLogin"], @source.ordered_events
  end
  
  def test_it_can_list_unique_events
    assert_equal ["socialLogin", "beginRegistration"], @source.unique_events
  end
  
  def test_it_can_list_unique_urls
    assert_equal 2, @source.unique_urls.count
  end
  
  def test_it_can_show_hour_to_hour_breakdown
    assert_equal ["Hour 12: had 1 event occurances.", "Hour 21: had 1 event occurances."], @source.count_event_per_hour(@source.payloads.first.event)
  end
  
  def test_total_times_recieved
    assert_equal 2, @source.number_of_times_event_receieved(@source.payloads.first.event)
  end
end