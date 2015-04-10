module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :payloads
    
    def hour_breakdown
      grouped = payloads.group_by { |pl| Time.parse(pl.requested_at).hour }
      sorted = grouped.sort_by { |k,v| k }
      sorted.flat_map { |element| "Hour #{element[0]}: had #{element[1].count} event occurances." }
    end
    
    def number_of_times_receieved
      payloads.count
    end
  end
end