# Sidekiq Queue Status

Middleware to add `/queue-status` endpoint. Useful for pinging services
such as Icinga or Nagios.

Lists latency for each sidekiq queue. The latency is the number of
seconds the oldest job (next in line) is waiting to be performed.

Under normal circumstances returns a `200 OK` status code. When latency
is higher than the 30s default threshold, a `503 Service Unavailable` is
returned.

Thresholds are configurable by setting `config.queue_tresholds` hash.
Key is queue name, value is latency threshold in seconds.

Response body is a JSON object, listing the latencies of all queues and
an array of error messages explaining which queues triggered a threshold
error.
```json
{
  latencies: {
    batch: 200,
    default: 1
  },
  errors: [“Queue batch above threshold of 100”]
}
```