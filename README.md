## 消息中间件使用示例

### 初始化

* 第一步 初始化环境
```ruby
bundle install
cp config/database.yml.example config/database.yml
# **edit database.yml**
bundle exec rake db:create
bundle exec rake db:migrate
```

* 第二步 启动控制台

通过 `bundle exec rails c` 进入 Rails 控制台

### 消息通信演示

* 异步任务消息

`MessagePublisher.publish("demo.demo", "hello world")`


* 消息广播


* 远程服务调用 RPC

