module TrafficSpy
  class Referrer < ActiveRecord::Base
    has_many :payloads
  end
end