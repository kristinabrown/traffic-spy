require './test/test_helper'

class LandingPagetest < MiniTest::Test
  include Capybara::DSL
  
  def test_homepage_links_to_sources_index
    visit '/'
    
    assert_equal '/', current_path
    assert page.has_content?("Hello")
    
    click_link "Sources List"

    assert_equal '/sources', current_path
    assert page.has_content?("Source Index")
  end
end