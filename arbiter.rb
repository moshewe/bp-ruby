class Arbiter

  attr_accessor :program, :selector

  def initialize(program = nil)
    @program = program
    @selector = DefaultEventSelector.new
  end

  def next_event
    p "arbiting next event"
    legal = program.legal_events
    puts "legal events: #{legal}"
    # if legal.empty?
    #   ask_for_external
    # end
    ev = select_event legal
    # puts "event selected is #{ev.inspect}"
    # if !ev && !program.in_pipe.empty?
    #   ev = program.in_pipe.shift
    # end
    if ev
      program.le = ev
      program.bp_loop
    else
      program.back_to_caller
    end
  end

  def select_event(legal)
    @selector.select_event legal
  end

  def ask_for_external
    program.back_to_caller
  end

end
