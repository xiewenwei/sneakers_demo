require 'sneakers'

class MessagePublisher
  # default timeout for remote call. unit is seconds
  REMOTE_CALL_DEFAULT_TIMEOUT = 5

  # sender message to sneaker exchange
  # @param name route_key for message
  # @param message
  def self.publish(name, message)
    publisher.publish message, to_queue: name
  end

  # call remote service via rabbitmq rpc
  # @param name route_key for service
  # @param message
  # @param options{timeout} [int] timeout. seconds.   optional
  # @return result of service
  # @raise Timeout::Error if timeout
  #
  def self.remote_call(name, message, options = {})
    @client ||= SneakersRpcClient.new(publisher)
    Timeout.timeout(options[:timeout] || REMOTE_CALL_DEFAULT_TIMEOUT) do
      @client.call name, message
    end
  end

  def self.publisher
    @publisher ||= ::Sneakers::Publisher.new
  end

end
