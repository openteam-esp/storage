require 'bunny'

class MessageMaker
  SUCCESS_QUEUE = 'updated files'

  def self.make_message(message)
    amqp_client = Bunny.new(:logging => false)
    amqp_client.start
    queue = amqp_client.queue(SUCCESS_QUEUE, :durable => true, :auto_delete => false, :exclusive => false)
    queue.publish(message, :persistent => true)
    amqp_client.stop
  end
end
