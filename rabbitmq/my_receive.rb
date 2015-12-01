#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require "json"

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel
x    = ch.fanout("hello_broadcast")
q    = ch.queue("vincnet_hello")

q.bind(x)

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    data = body =~ /^{/ ? JSON.load(body) : body
    puts " [x] Received #{data.inspect}"
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
