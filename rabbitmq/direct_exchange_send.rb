
require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
x = ch.direct 'direct_x_test'

10.times do |i|
  x.publish "message #{i}", routing_key: 'direct_x.changed'
end

conn.close
