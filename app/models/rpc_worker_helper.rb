module RpcWorkerHelper
  def packer
    MessagePacker.new "sneaker_demo"
  end

  def work_with_params(message, delivery_info, metadata)
    puts "get #{message}"
    request_data, from = packer.unpack_request message
    puts "call from #{from}"
    response_data = call request_data
    result = packer.pack_response response_data

    publish(result, to_queue: metadata.reply_to, correlation_id: metadata.correlation_id)

    ack!
  end

end