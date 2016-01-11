
require 'sneakers'
require 'sneakers/metrics/logging_metrics'

opts = {
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct,
  workers: 2,
  daemonize: false,
  pid: "tmp/pid/sneakers.pid",
  metrics: Sneakers::Metrics::LoggingMetrics.new
}

Sneakers.configure(opts)

Sneakers.logger.level = Logger::INFO

SneakersPacker.configure do |conf|
  conf.rpc_timeout = 3             # rpc client timeout. default is 5 seconds.
  conf.app_name = "sneakers_demo"  # rpc client or server app's name. default is 'unknown'
end