class Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  validates :identifier, uniqueness: true
  has_many :payloads
  
  def self.order_urls(identifier)
    urls = find_by(identifier: identifier).payloads.order('url_id')
    urls.map { |p| p.url.address }.uniq
  end
end
