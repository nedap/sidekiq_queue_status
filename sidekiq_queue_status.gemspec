# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq_queue_status/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq_queue_status"
  spec.version       = SidekiqQueueStatus::VERSION
  spec.authors       = ["Matthijs Langenberg"]
  spec.email         = ["mlangenberg@gmail.com"]
  spec.summary       = %q{Monitor Sidekiq queue status in Rails}
  spec.description   = %q{
                            This Gem adds a /queue-status endpoint to your Rails app.
                            Useful for monitoring your Sidekiq queues with Icinga or Nagios.
                            Normally returns a 200 OK, returns 503 Service Unavailable
                            when stats such as queue latency are too high.
                          }
  spec.homepage      = "https://github.com/nedap/sidekiq_queue_status"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", "> 3.0"
  spec.add_dependency "sidekiq", "> 2.5"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
