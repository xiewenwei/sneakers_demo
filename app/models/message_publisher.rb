require 'sneakers'

class MessagePublisher
  # sender message to sneaker exchange
  # @param name route_key for message
  # @param message
  def self.publish(name, message)
    publisher.publish message, to_queue: name
  end

  # call remote service via rabbitmq rpc
  # @param name route_key for service
  # @param message
  # @return result of service
  def self.remote_call(name, message)
    @client ||= SneakersRpcClient.new(publisher)
    @client.call name, message
  end

  def self.publisher
    @publisher ||= ::Sneakers::Publisher.new
  end

end
