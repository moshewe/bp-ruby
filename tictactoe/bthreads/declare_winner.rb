require_relative '../../b_thread'
require_relative '../ttt_events'

class DeclareWinner < BThread
  include TTTEvents

  def initialize
    BThread.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    @name = 'DeclareWinner'
  end

  def body(le)
    eset = event_set('WinnerDecided', xwin, owin, draw)
    e = bsync ({:request => none,
                :wait => eset,
                :block => none})
    case e
      when xwin
        msg = 'X wins', title = 'We have a winner!'
      when owin
        msg = 'Y wins', title = 'We have a winner!'
      when draw
        msg = 'Draw', title = 'It\'s a draw!'
    end
    ttt.msg title, msg
    bsync ({:request => game_over, :wait => none, :block => none})
  end

end