module Prome
  module Rails
    def self.install!
      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, ending, _, payload|
        labels = {
          controller: payload[:params]["controller"],
          action: payload[:params]["action"],
          status: payload[:status],
          format: payload[:format],
          method: payload[:method].downcase
        }
        duration = ending - start

        Prome.get(:response_time_summary).observe({}, duration)
        Prome.get(:action_response_time_summary).observe(labels, duration)
        Prome.get(:rails_requests_total).increment(labels)
      end
    end
  end
end