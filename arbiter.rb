class Arbiter

  attr_accessor :program

  def next_event
    p "arbiting next event"
    sleep(1)
    legal = []
    program.bthreads.each do |bt|
      p "%s asked for %s " %[bt.inspect, bt.request]
      sleep(1)
      legal.concat bt.request
    end

    program.bthreads.each do |bt|
      legal.select! { |e| !bt.block.include? e }
    end

    if legal.empty?
      p "need external event, legal is empty!"
      sleep(1)
      nil
    else
      puts "legal events: #{legal}"
      sleep(1)
      e = legal.sample
      puts "event selected is #{e}"
      sleep(1)
      e
    end
  end
end
