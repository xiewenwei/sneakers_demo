## 消息中间件使用示例

### 初始化

* 第 1 步 初始化环境
```ruby
bundle install
cp config/database.yml.example config/database.yml
# **edit database.yml**
bundle exec rake db:create
bundle exec rake db:migrate
```

* 第 2 步 启动 worker 处理进程
通过 `bundle exec rake sneakers:run` 启动 worker 处理进程，然后可以通过 `tail -f log/sneakers.log` 查看 worker 日志。

* 第 3 步 启动演示控制台
通过 `bundle exec rails c` 进入 Rails 控制台，然后通过下面的命令进行试验。

### 消息通信演示

* 异步任务消息

  - `MessagePublisher.publish("demo.demo", "hello world")`
  - `MessagePublisher.publish("demo.simple", "hello world")` 带最大出错次数尝试

* 消息广播

  - `MessagePublisher.publish("demo.suprise", "hello world")`

* 远程服务调用 RPC

  - `MessagePublisher.remote_call("demo.rpc_server", 102)`
  - `MessagePublisher.remote_call("demo.posts_count", 0)`
