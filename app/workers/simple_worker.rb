require 'sneakers'


class SimpleWorker
  include SneakersPacker::CommonWorker

  from_queue "demo.simple", {
                              handler: Sneakers::Handlers::Maxretry,
                              arguments: {
                                :'x-dead-letter-exchange' => 'demo.simple-retry'
                              },
                              retry_timeout: 5000,
                              retry_max_times: 3
                            }

  def call(data)
    logger.info "data is #{data.inspect}"
    raise "something wrong"
  end
end
