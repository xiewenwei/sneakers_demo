
require 'sneakers'
require 'sneakers/metrics/logging_metrics'
require 'sneakers/handlers/maxretry'

opts = {
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct,
  workers: 2,
  daemonize: false,
  pid_path: "tmp/pids/sneakers.pid",
  log: ActiveSupport::Logger.new("#{Rails.root}/log/sneakers.log"),
  threads: 5,
  share_threads: true,
  timeout_job_after: 20,
  metrics: Sneakers::Metrics::LoggingMetrics.new
}

Sneakers.configure(opts)

Sneakers.logger.level = Logger::INFO #Logger::DEBUG
Sneakers.logger.formatter = Sneakers::Support::ProductionFormatter

Sneakers.configure_server do |config|
  Sneakers.configure after_fork: Proc.new { ActiveRecord::Base.establish_connection }
end

SneakersPacker.configure do |conf|
  conf.rpc_timeout = 3             # rpc client timeout. default is 5 seconds.
  conf.app_name = "sneakers_demo"  # rpc client or server app's name. default is 'unknown'
end
