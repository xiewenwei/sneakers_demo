class RpcServerWorker
  include Sneakers::Worker
  from_queue :rpc_server, exchange: 'dumy_rpc_server'

  def work_with_params(msg, delivery_info, metadata)
    puts "get #{msg}"
    resp = msg.to_i ** 3

    self.class.direct_publish(resp.to_s, to_queue: metadata.reply_to, correlation_id: metadata.correlation_id)

    ack!
  end

  def self.direct_publish(msg, opts)
    @publisher ||= Sneakers::Publisher.new default_exchange: true
    @publisher.publish(msg, opts)
  end
end
