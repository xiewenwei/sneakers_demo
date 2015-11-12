class OneWorker
  include Sneakers::Worker
  from_queue :one_name,
             exchange_options: { type: 'topic' },
             routing_key: ['#'],
             exchange: 'dumy'

  def work(name)
    puts "one: #{name}"
    ack!
  end
end