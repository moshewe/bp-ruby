require_relative '../../b_thread'

class DetectDraw < BThread
  include TTTEvents

  def initialize
    BThread.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    @name = 'DetectDraw'
  end

  def body(le)
    bsync({:request => none,
           :wait => event_of_class(Move),
           :block => none}).times(8)
    bsync({:request => draw,
           :wait => none,
           :block => none})
  end
end