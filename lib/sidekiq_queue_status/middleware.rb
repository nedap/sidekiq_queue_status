require 'sidekiq/api'

module SidekiqQueueStatus
  class Middleware
    HEADERS = {
      'Content-Type' => 'application/json',
      'Cache-Control' => 'no-cache'
    }

    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"] =~ %r{\A/queue-status\Z}
        metrics = Metric.all
        body = { latencies: metrics.latencies, failure_percentage: metrics.failure_rate, errors: metrics.errors }.to_json
        status = metrics.errors.any? ? 503 : 200
        [status, HEADERS, [body]]
      else
        @app.call(env)
      end
    end

  end
end