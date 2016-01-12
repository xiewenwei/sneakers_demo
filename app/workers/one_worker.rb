class OneWorker
  include SneakersPacker::CommonWorker

  from_queue "demo.one", routing_key: "demo.suprise"

  def call(data)
    logger.info "data is #{data.inspect}"
  end
end
