require 'rails/railtie'

module SidekiqQueueStatus
  class Railtie < Rails::Railtie
    config.queue_tresholds = {}
    config.queue_failure_rate = nil
    initializer "sidekiq_queue_status.configure_rails_initialization" do |app|
      app.middleware.use SidekiqQueueStatus::Middleware, app.config.queue_tresholds, app.config.queue_failure_rate
    end
  end
end