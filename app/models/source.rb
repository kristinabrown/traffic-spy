class Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  validates :identifier, uniqueness: true
  has_many :payloads
  
  def self.order_urls(identifier)
    payloads = find_by(identifier: identifier).payloads.order('url_id')
    payloads.map { |pl| pl.url.address }.uniq
  end
  
  def self.user_agent_info(identifier)
    payloads = find_by(identifier: identifier).payloads
    payloads.map { |pl| pl.user_agent.browser_info }
  end
  #need to ask about wrapping user agent in a module so it doesn't get 
  #the way of the gem. TrafficSpy::UserAgent works, but then 
  # there is an error with user_agent_info about arel tables not existing 
  #for UserAgent
  def self.broswer_info(identifier)
    user_agent_info(identifier).map do |info_string|
      UserAgent.parse(info_string).browser
    end
  end
  
  def self.os_info(identifier)
    user_agent_info(identifier).map do |info_string|
      UserAgent.parse(info_string).platform
    end
  end
  
  def self.screen_resolution_height(identifier)
    payloads = find_by(identifier: identifier).payloads
    payloads.map { |pl| pl.resolution.height }
  end
  
  def self.screen_resolution_width(identifier)
    payloads = find_by(identifier: identifier).payloads
    payloads.map { |pl| pl.resolution.width }
  end
  
end
