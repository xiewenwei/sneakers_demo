class DemoWorker
  include Sneakers::Worker
  from_queue :demo

  def work(msg)
    puts "msg is #{msg}"
    Post.create!(title: "message from mq", body: msg, published: false)
    ack!
  end
end