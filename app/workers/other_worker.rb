class OtherWorker
  include Sneakers::Worker
  include CommonWorkerHelper

  from_queue :other_name, routing_key: "demo.suprise"

  def call(data)
    puts "other: #{data}"
  end
end