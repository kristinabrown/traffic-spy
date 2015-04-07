class Payload < ActiveRecord::Base
  belongs_to :source
  belongs_to :url
  belongs_to :referrer
  belongs_to :event
  belongs_to :ip
  belongs_to :request_type
  belongs_to :resolution
  belongs_to :user_agent
end