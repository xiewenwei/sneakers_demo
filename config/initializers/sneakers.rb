
require 'sneakers'
require 'sneakers/metrics/logging_metrics'

opts = {
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct,
  workers: 2,
  daemonize: true,
  pid_path: "tmp/pids/sneakers.pid",
  log: ActiveSupport::Logger.new("#{Rails.root}/log/sneakers.log"),
  threads: 5,
  timeout_job_after: 10,
  metrics: Sneakers::Metrics::LoggingMetrics.new
}

Sneakers.configure(opts)

Sneakers.logger.level = Logger::INFO
Sneakers.logger.formatter = Sneakers::Support::ProductionFormatter

SneakersPacker.configure do |conf|
  conf.rpc_timeout = 3             # rpc client timeout. default is 5 seconds.
  conf.app_name = "sneakers_demo"  # rpc client or server app's name. default is 'unknown'
end
