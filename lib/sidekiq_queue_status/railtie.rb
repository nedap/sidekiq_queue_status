require 'rails/railtie'

module SidekiqQueueStatus
  class Railtie < Rails::Railtie
    config.queue_tresholds = {}
    initializer "sidekiq_queue_status.configure_rails_initialization" do |app|
      app.middleware.use SidekiqQueueStatus::Middleware, app.config.queue_tresholds
    end
  end
end