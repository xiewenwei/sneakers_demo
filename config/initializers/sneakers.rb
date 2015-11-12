
require 'sneakers'

opts = {
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct,
  workers: 2,
  daemonize: false,
  pid: "tmp/pid/sneakers.pid"
}

Sneakers.configure(opts)

Sneakers.logger.level = Logger::INFO
