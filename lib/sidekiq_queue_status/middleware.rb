require 'sidekiq/api'

module SidekiqQueueStatus
  class Middleware
    DEFAULT_TRESHOLD = 30
    HEADERS = {
      'Content-Type' => 'application/json',
      'Cache-Control' => 'no-cache'
    }

    def initialize(app, configured_tresholds)
      @app = app
      @latency_treshold = Hash.new(DEFAULT_TRESHOLD).merge(configured_tresholds)
    end

    def call(env)
      if env["PATH_INFO"] =~ %r{\A/queue-status\Z}
        errors = []
        queues.each do |name, latency|
          max_latency = @latency_treshold[name]
          errors << "Queue #{name} above threshold of #{max_latency}s" if latency > max_latency
        end
        body = { latencies: queues, errors: errors }.to_json
        status = errors.any? ? 503 : 200
        [status, HEADERS, [body]]
      else
        @app.call(env)
      end
    end

    def queues
      Sidekiq::Queue.all.map { |q| [q.name, q.latency.to_i] }.to_h
    end
  end
end