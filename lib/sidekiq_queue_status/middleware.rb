require 'sidekiq/api'

module SidekiqQueueStatus
  class Middleware
    DEFAULT_TRESHOLD = 30
    DEFAULT_FAILURE_RATE_PERC = 10
    HEADERS = {
      'Content-Type' => 'application/json',
      'Cache-Control' => 'no-cache'
    }

    def initialize(app, configured_tresholds, failure_rate)
      @app = app
      @latency_treshold = Hash.new(DEFAULT_TRESHOLD).merge(configured_tresholds)
      @max_failure_rate = failure_rate || DEFAULT_FAILURE_RATE_PERC
    end

    def call(env)
      if env["PATH_INFO"] =~ %r{\A/queue-status\Z}
        errors = []
        queues.each do |name, latency|
          max_latency = @latency_treshold[name]
          errors << "Queue #{name} above threshold of #{max_latency}s" if latency > max_latency
        end
        failure_rate = calculate_failure_rate
        errors << "Failure rate above #{@max_failure_rate}%" if failure_rate > @max_failure_rate
        body = { latencies: queues, failure_percentage: failure_rate, errors: errors }.to_json
        status = errors.any? ? 503 : 200
        [status, HEADERS, [body]]
      else
        @app.call(env)
      end
    end

    def queues
      Sidekiq::Queue.all.map { |q| [q.name, q.latency.to_i] }.to_h
    end

    def calculate_failure_rate
      stats = Sidekiq::Stats::History.new(1)
      processed, failed = [stats.processed, stats.failed].map { |h| h.values.last }
      val = (failed.to_f / processed.to_f) * 100.0
      val > 0 ? val.to_i : 0
    end
  end
end