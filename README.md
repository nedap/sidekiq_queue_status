# Sidekiq Queue Status

Rails Middleware to add `/queue-status` endpoint. Useful for pinging
services such as Icinga or Nagios.

Lists latency for each sidekiq queue. The latency is the number of
seconds the oldest job (next in line) is waiting to be performed.

Under normal circumstances returns a `200 OK` status code. When latency
is higher than the 30s default threshold, or when the failure rate
on the current day is higher than 10%, a `503 Service Unavailable`
is returned.

Thresholds are configurable by setting `config.queue_tresholds` hash.
Key is queue name, value is latency threshold in seconds.
Set `config.queue_failure_rate` to override the default failure rate.

```ruby
# config/application.rb
Application.configure do
  config.queue_tresholds['batch'] = 10.minutes
  config.queue_failure_rate = 5
end
```

Response body is a JSON object, listing the latencies of all queues and
an array of error messages explaining which queues triggered a threshold
error.

```json
{
  "latencies": {
    "batch": 200,
    "default": 1,
    "failure_percentage": 25
  },
  "errors": ["Queue batch above threshold of 100", "Failure rate above 5%"]
}
```

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq_queue_status'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq_queue_status

## Contributing

1. Fork it ( http://github.com/nedap/sidekiq_queue_status/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
