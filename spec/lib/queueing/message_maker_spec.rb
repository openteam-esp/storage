require 'spec_helper'

describe MessageMaker do
  it "doesn't pollute subsequent messages" do
    bunnies = []
    bunnies << mock('bunny')
    bunnies[0].stub(:start)
    bunnies[0].stub(:stop)
    bunnies[0].stub(:exchange)
    bunnies[0].stub(:queue).and_return do |*args|
      queue = mock('queue', :name => 'my queue')
      queue.should_receive(:publish).with("Hello queue", :persistent => true)
      queue
    end

    bunnies << mock('bunny')
    bunnies[1].stub(:start)
    bunnies[1].stub(:stop)
    bunnies[1].stub(:exchange)
    bunnies[1].stub(:queue)
    bunnies[1].stub(:queue).and_return do |*args|
      queue = mock('queue', :name => 'my queue')
      queue.should_receive(:publish).with("File was updated", :persistent => true)
      queue
    end

    Bunny.should_receive(:new).twice.and_return do |*args|
      bunnies.shift #shifts off the first instance in the array and returns it
    end

    MessageMaker.make_message("Hello queue")
    MessageMaker.make_message("File was updated")
  end
end
