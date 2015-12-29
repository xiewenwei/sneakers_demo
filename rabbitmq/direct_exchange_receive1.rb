require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
x = ch.direct 'direct_x_test'

q = ch.queue "direct_x_queue1"

q.bind x, routing_key: 'direct_x.changed'

begin
  q.subscribe(block: true) do |delivery_info, properties, body|
    puts "NO1: receive #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close

  exit(0)
end
