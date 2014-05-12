module SidekiqQueueStatus
  class QueueLatency < Metric
    DEFAULT_TRESHOLD = 30
    def monitor
      queues_with_latency.each do |name, latency|
        error("Queue #{name} above threshold of #{max_latency(name)}s") if latency > max_latency(name)
      end
    end

    def queues_with_latency
      Hash[*Sidekiq::Queue.all.map { |q| [q.name, q.latency.to_i] }.flatten]
    end

    def max_latency(name)
      Hash.new(DEFAULT_TRESHOLD).merge(Metric.config['queue_tresholds'])[name]
    end
  end
end