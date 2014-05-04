module SidekiqQueueStatus
  class Metric
    Result = Struct.new :latencies, :failure_rate, :errors

    class << self
      attr_accessor :config
      def all
        metrics = QueueLatency.new, FailureRate.new
        errors = metrics.map(&:errors).flatten
        Result.new(*metrics.map(&:result), errors)
      end
    end

    attr_reader :errors, :result
    def initialize
      @errors = []
      @result = monitor
    end

    def error(message)
      @errors << message
    end
  end
end