class OtherWorker
  include Sneakers::Worker
  from_queue :other_name,
             exchange_options: { type: 'topic' },
             routing_key: ['#'],
             exchange: 'dumy'

  def work(name)
    puts "other: #{name}"
    ack!
  end
end