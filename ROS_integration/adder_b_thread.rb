require '../bp'

class AdderBThread < BThread


  def initialize
    super
    @name = "Adder"
  end

  def body(le)
    p "Adder BThread is waiting for 1 from user@stdin"
    bsync({:wait => NumEvent.new(1)})
    program.emit(NumEvent.new 2)
  end

end

class NumEvent < BEvent

  attr_accessor :num

  def initialize(num)
    @num = num.to_i
    @name = "#{@num}-Event"
  end

  def ==(ev)
    ev.is_a?(NumEvent) &&
                 ev.num == self.num
  end

end

arb = Arbiter.new
prog = BProgram.new(arb)
arb.program = prog
bt = AdderBThread.new
bt.program = prog
prog.bthreads = [bt]
prog.start
p "firing NumEvent with whatever user enters now in stdin"
prog.fire(NumEvent.new gets)
p "printing event emitted by program"
puts prog.out_pipe.shift.inspect