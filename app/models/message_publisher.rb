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
    client = RabbitmqRpcClient.new *fetch_channel_and_exchange
    client.call name, message
  end

  def self.publisher
    @publisher ||= ::Sneakers::Publisher.new
  end

  # hack seankers publisher to get channel and exchange
  def self.fetch_channel_and_exchange
    ret = nil

    publisher.instance_eval do
      @mutex.synchronize do
        ensure_connection! unless connected?
      end
      ret = [@channel, @exchange]
    end

    ret
  end
end
