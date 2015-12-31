module CommonWorkerHelper
  def packer
    MessagePacker.new "sneaker_demo"
  end

  def work(message)
    puts "get #{message}"
    request_data, from = packer.unpack_request message
    puts "call from #{from}"
    call request_data
    ack!
  end
end