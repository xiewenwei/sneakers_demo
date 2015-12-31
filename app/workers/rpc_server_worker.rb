class RpcServerWorker
  include Sneakers::Worker
  include RpcWorkerHelper

  from_queue :rpc_server

  def call(data)
    data.to_i ** 3
  end
end
