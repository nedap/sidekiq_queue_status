module SidekiqQueueStatus
  class FailureRate < Metric
    DEFAULT_FAILURE_RATE_PERC = 10
    def monitor
      calculate_failure_rate.tap do |failure_rate|
        error("Failure rate above #{max_failure_rate}%") if failure_rate > max_failure_rate
      end
    end

    def calculate_failure_rate
      stats = Sidekiq::Stats::History.new(1)
      processed, failed = [stats.processed, stats.failed].map { |h| h.values.last }
      val = (failed.to_f / processed.to_f) * 100.0
      val > 0 ? val.to_i : 0
    end

    def max_failure_rate
      Metric.config['queue_failure_rate'] || DEFAULT_FAILURE_RATE_PERC
    end
  end
end