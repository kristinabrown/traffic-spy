module TrafficSpy
  class Source < ActiveRecord::Base
    validates_presence_of :identifier, :root_url
    validates :identifier, uniqueness: true
    has_many :payloads

    def ordered_urls
      payloads.order('url_id').map { |pl| pl.url.address }.uniq
    end

    def user_agent_info
      payloads.map { |pl| pl.user_agent.browser_info }
    end

    def browser_info
      user_agent_info.map do |info_string|
        ::UserAgent.parse(info_string).browser
      end
    end

    def os_info
      user_agent_info.map do |info_string|
        ::UserAgent.parse(info_string).platform
      end
    end

    def screen_resolution_width_height
      payloads.map do |pl|
        "#{pl.resolution.width}X#{pl.resolution.height}"
      end
    end

    def ordered_url_response_times
      response_times_ordered.map do |pl|
        "#{pl.url.address}: #{pl.url.average_response_time}"
      end.uniq
    end

    def ordered_events
      payloads.order('event_id').map { |pl| pl.event.name }.reverse.uniq
    end

    def unique_events
      payloads.map { |pl| pl.event.name }.uniq
    end

    def unique_urls
      payloads.map { |pl| pl.url }.uniq
    end
    
    def events_grouped_by_hour(event)
      payloads.where(event_id: event.id).group_by { |pl| Time.parse(pl.requested_at).hour }
    end
    
    def count_event_per_hour(event)
      sorted = events_grouped_by_hour(event).sort_by { |k,v| k }
      sorted.flat_map do |element|
        "Hour #{element[0]}: had #{element[1].count} event occurances."
      end
    end

    def number_of_times_event_receieved(event)
      payloads.where(event_id: event.id).count
    end

    private

    def response_times_ordered
      payloads.sort_by { |pl| pl.url.average_response_time }.reverse
    end
  end
end