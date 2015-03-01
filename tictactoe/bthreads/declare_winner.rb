require_relative '../../b_thread'
require_relative '../ttt_events'

class DeclareWinner < BThread
  include TTTEvents

  @name = 'DeclareWinner'
  @bodyfunc = lambda { |e|
    e = bsync ({:request => none,
            :wait => event_set('WinnerDecided', xwin, owin, draw),
            :block => none})

    msg = 'X wins' if e == xwin
    msg = 'Y wins' if e == owin
    msg = 'Draw' if e == draw
    ttt.msg msg
    bsync game_over, none, none
  }

end