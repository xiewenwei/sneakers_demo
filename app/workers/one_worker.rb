class OneWorker
  include SneakersPacker::CommonWorker

  from_queue :one_name, routing_key: "demo.suprise"

  def call(data)
    puts "other: #{data}"
  end
end
