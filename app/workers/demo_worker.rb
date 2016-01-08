class DemoWorker
  include SneakersPacker::CommonWorker
  from_queue :demo

  def call(data)
    puts "data is #{data}"
    Post.create!(title: "message from mq", body: data, published: false)
  end
end
