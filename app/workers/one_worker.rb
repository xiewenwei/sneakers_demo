class OneWorker
  include Sneakers::Worker
  from_queue :one_name, routing_key: "demo.suprise"

  def work(message)
    puts "one: #{message}"
    ack!
  end
end