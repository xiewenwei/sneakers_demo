
class SneakersRpcClient
  attr_reader :reply_queue
  attr_accessor :response, :call_id
  attr_reader :lock, :condition

  def initialize(publisher)
    @publisher = publisher
    @consumer = build_reply_queue
  end

  def call(name, message)
    self.call_id = SecureRandom.uuid

    @exchange.publish(message.to_s,
               routing_key:    name.to_s,
               correlation_id: call_id,
               reply_to:       @reply_queue.name)

    lock.synchronize{ condition.wait(lock) }
    response
  end

  private

  def build_reply_queue
    channel, exchange = fetch_channel_and_exchange
    @channel, @exchange = channel, exchange

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

  # hack seankers publisher to get channel and exchange
  def fetch_channel_and_exchange
    ret = nil

    @publisher.instance_eval do
      @mutex.synchronize do
        ensure_connection! unless connected?
      end
      ret = [@channel, @exchange]
    end

    ret
  end
end
