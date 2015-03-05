class Arbiter

  attr_accessor :program

  def next_event
    p "arbiting next event"
    legal = program.legal_events
    if legal.empty?
      p "need external event, legal is empty!"
      nil
    else
      puts "legal events: #{legal}"
      e = select_event legal
      puts "event selected is #{e}"
      e
    end
  end

  def select_event(legal)
    legal.sample
  end
end
