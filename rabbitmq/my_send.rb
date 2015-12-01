#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require "json"

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel
x    = ch.fanout("hello_broadcast")

data = {name: 'vincent', age: 36, weights: [67, 68, 69, 70]}
msg = JSON.dump(data)
x.publish(msg)
x.publish("very good!")

puts " [x] Sent 'broadcast Hello World!'"

conn.close
