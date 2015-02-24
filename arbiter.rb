class Arbiter

  attr_accessor :program

  def next_event
    p "arbiting next event"
    sleep(1)
    select_event
  end

  def select_event
    legal = program.legal_events
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
