#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require "thread"
require "benchmark"

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel


class FibonacciClient
  attr_reader :reply_queue
  attr_accessor :response, :call_id
  attr_reader :lock, :condition

  def initialize(ch, server_queue)
    @ch             = ch
    @x              = ch.exchange("dumy_rpc_server", type: 'direct', durable: true)

    @server_queue   = server_queue
    #@reply_queue    = ch.queue("", :exclusive => true)
    #@reply_queue.bind(@x, routing_key: @reply_queue.name)

    @reply_queue = ch.queue("amq.rabbitmq.reply-to")

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

  def call(n)
    self.call_id = self.generate_uuid
    puts "reply_queue.name is #{reply_queue.name}"
    @x.publish(n.to_s,
      :routing_key    => @server_queue,
      :correlation_id => call_id,
      :reply_to       => @reply_queue.name)

    lock.synchronize{condition.wait(lock)}
    response
  end

  protected

  def generate_uuid
    # very naive but good enough for code
    # examples
    "#{rand(1000000)}"
  end
end


client   = FibonacciClient.new(ch, "rpc_server")

result = Benchmark.measure do
  3000.times do |index|
    response = client.call(index)
    puts " Arg is #{index}. Got #{response}."
  end
end
puts result

ch.close
conn.close
