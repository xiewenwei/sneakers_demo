
class RabbitmqRpcClient
  attr_reader :reply_queue
  attr_accessor :response, :call_id
  attr_reader :lock, :condition

  def initialize(channel, exchange)
    @channel             = channel
    @exchange            = exchange

    # TODO avoid to create queue frequency
    @reply_queue    = channel.queue("", exclusive: true)
    @reply_queue.bind(exchange, routing_key: @reply_queue.name)

    @lock      = Mutex.new
    @condition = ConditionVariable.new
    that       = self

    @reply_queue.subscribe(manual_ack: false) do |delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        that.response = payload.to_i
        that.lock.synchronize{that.condition.signal}
      end
    end
  end

  def call(name, message)
    self.call_id = SecureRandom.uuid

    @exchange.publish(message.to_s,
               routing_key:    name.to_s,
               correlation_id: call_id,
               reply_to:       @reply_queue.name)

    lock.synchronize{condition.wait(lock)}
    response
  end

end
