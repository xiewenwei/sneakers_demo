class OtherWorker
  include Sneakers::Worker
  from_queue :other_name, routing_key: "demo.suprise"

  def work(message)
    puts "other: #{message}"
    ack!
  end
end