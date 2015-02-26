require_relative '../../bp'

class EnforceTurns < BThread
  include(TTTEvents)

  @bodyfunc = lambda{|ev|
    while(true)
      bsync({:request => none,
            :wait => xevents,
            :block => oevents})
      bsync({:request => none,
             :wait => oevents,
             :block => xevents})
    end
  }
end