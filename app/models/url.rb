module TrafficSpy
  class Url < ActiveRecord::Base
    has_many :payloads

    def average_response_time
      payloads.average(:responded_in).to_f.round
    end

    def longest_response_time
      payloads.order(:responded_in).last.responded_in
    end

    def shortest_response_time
      payloads.order(:responded_in).first.responded_in
    end

    def verbs
      payloads.map { |pl| pl.request_type.verb_name }
    end

    def most_popular_referrers
      sorted_url_keys.map { |k,v| "#{k}:#{v.count}" }.reverse
    end

    def most_popular_user_agents
      sorted_agents.flat_map do |element|
        "#{element[0]}: #{element[1].count}"
      end.reverse
    end

    private

    def sorted_agents
      agents = payloads.group_by { |pl| pl.user_agent.browser_info }
      agents.sort_by { |k,v| v.count }
    end

    def sorted_url_keys
      sorted_urls = payloads.group_by { |pl| pl.referrer.referrer_url }
      sorted_urls.sort_by { |k,v| v.count }
    end
  end
end