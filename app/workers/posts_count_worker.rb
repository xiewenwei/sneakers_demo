class PostsCountWorker
  include Sneakers::Worker
  from_queue :posts_count

  def work_with_params(msg, delivery_info, metadata)
    resp = Post.count

    if msg.to_i > 0
      sleep msg.to_i
    end

    publish(resp.to_s, to_queue: metadata.reply_to, correlation_id: metadata.correlation_id)

    ack!
  end

end