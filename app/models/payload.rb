class Payload < ActiveRecord::Base
  validates_presence_of :url_id, :requested_at, :responded_in, :referrer_id, :request_type_id,
                        :event_id, :user_agent_id, :resolution_id, :ip_id
                    

  belongs_to :source
  belongs_to :url
  belongs_to :referrer
  belongs_to :event
  belongs_to :ip
  belongs_to :request_type
  belongs_to :resolution
  belongs_to :user_agent
end
