class OtherWorker
  include SneakersPacker::CommonWorker

  from_queue "demo.other", routing_key: "demo.suprise"

  def call(data)
    logger.info "data is #{data.inspect}"
  end
end