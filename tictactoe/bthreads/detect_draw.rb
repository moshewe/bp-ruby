require_relative '../../b_thread'

class DetectDraw < BThread
  include TTTEvents

  @bodyfunc = lambda { |ev|
    bsync({:request => none,
           :wait => event_of_class(Move),
           :block => none}).times(8)
    bsync({:request => draw,
           :wait => none,
           :block => none})
  }

end