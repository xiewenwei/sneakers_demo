class DemoWorker
  include SneakersPacker::CommonWorker
  from_queue "demo.demo"

  def call(data)
    logger.info "data is #{data.inspect}"
    Post.create!(title: "message from mq", body: data, published: false)
  end
end
