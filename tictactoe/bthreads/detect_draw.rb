require_relative '../../b_thread'

class DetectDraw < BThread
  include TTTEvents

  def initialize
    # BThread.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    super
    @name = 'DetectDraw'
  end

  def body(le)
    9.times do |i|
      bsync({:request => none,
             :wait => event_of_class(Move),
             :block => none})
    end
    bsync({:request => draw,
           :wait => none,
           :block => event_of_class(Move)})
  end
end