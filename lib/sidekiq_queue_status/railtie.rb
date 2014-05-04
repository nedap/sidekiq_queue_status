require 'rails/railtie'

module SidekiqQueueStatus
  class Railtie < Rails::Railtie
    config.queue_tresholds = {}
    config.queue_failure_rate = nil
    initializer "sidekiq_queue_status.configure_rails_initialization" do |app|
      Metric.config = {}
      Metric.config['queue_tresholds'] = app.config.queue_tresholds
      Metric.config['queue_failure_rate'] = app.config.queue_failure_rate
      app.middleware.use SidekiqQueueStatus::Middleware
    end
  end
end