class PostsCountWorker
  include SneakersPacker::RpcWorker

  from_queue "demo.posts_count"

  def call(data)
    result = Post.count

    if data.to_i > 0
      sleep data.to_i
    end

    result
  end

end