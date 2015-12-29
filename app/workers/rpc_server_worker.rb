class RpcServerWorker
  include Sneakers::Worker
  from_queue :rpc_server

  def work_with_params(msg, delivery_info, metadata)
    puts "get #{msg}"
    resp = msg.to_i ** 3

    publish(resp.to_s, to_queue: metadata.reply_to, correlation_id: metadata.correlation_id)

    ack!
  end

end
