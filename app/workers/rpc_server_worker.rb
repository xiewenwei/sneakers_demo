class RpcServerWorker
  include SneakersPacker::RpcWorker

  from_queue "demo.rpc_server"

  def call(data)
    data.to_i ** 3
  end
end
