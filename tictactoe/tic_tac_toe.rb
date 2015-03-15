require 'Qt4'
require_relative 'bthreads/tttb_threads'
Dir['../arbiter_event_selectors/*'].each { |file| require file }
Dir['../search/*'].each { |file| require file }

class TicTacToe
  include TTTBThreads, TTTEvents

  attr_accessor :board, :gui,
                :program, :bthreads,
                :enforcer, :staken

  def initialize
    # TTTBThreads.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    @board = Hash.new 0
    terminal = lambda { |bps|
      (bps.program.le == TTTEvents.xwin) ||
          (bps.program.le == TTTEvents.owin)
    }
    h = lambda { |bps|
      case bps.program.le
        when TTTEvents.xwin
          puts bps.inspect + "'s val is -1"
          -1
        when TTTEvents.owin
          puts bps.inspect + "'s val is 1"
          1
        else
          puts bps.inspect + "'s val is 0"
          0
      end
    }
    # arb.selector = StepAndSetGivenSelector.new arb, arb.selector
    arb = MinimaxArbiter.new nil, :O, h, terminal
    @program = BProgram.new arb
    arb.program = @program
    init_bthreads
    arb.sim_bthreads = @sim_bthreads
    arb.enforcer = @enforcer
    @program.start
    init_gui
  end

  def init_gui
    @gui = Qt::Application.new(ARGV)

    quitb = Qt::PushButton.new('Quit') do
      connect(SIGNAL :clicked) { Qt::Application.instance.quit }
    end

    ttt = self
    butts = (0..2).map { |row|
      (0..2).map { |col|
        Qt::PushButton.new do
          connect(SIGNAL :clicked) {
            setText ttt.enforcer.current.id2name
            set_enabled false
            puts "val for (#{row},#{col}) is " +
                     ttt.enforcer.current.id2name
            ttt.program.fire ttt.enforcer.make_move(row, col)
          }
        end
      }
    }.flatten

    grid = Qt::GridLayout.new
    grid.set_spacing 0
    for i in 1..3 do
      for j in 1..3 do
        grid.add_widget butts.shift, i, j
      end
    end

    window = Qt::Widget.new do
      self.window_title = 'BP TicTacToe'
      self.layout = Qt::VBoxLayout.new do
        addLayout grid
        add_widget(quitb, 0, Qt::AlignRight)
      end
      show
    end

    gui.set_active_window window
    gui.exec
  end

  def init_bthreads
    @enforcer = EnforceTurns.new
    @staken = SquareTaken.gen_all_st
    @sim_bthreads = MoveSimulator.gen_all_move_sim @enforcer
    @bthreads = [DeclareWinner.new,
                 DetectDraw.new,
                 @enforcer] + DetectWin.gen_all_wins +
        @staken + @sim_bthreads
    @bthreads.each do |bt|
      bt.program = program
    end
    program.bthreads = @bthreads
  end

  def msg(title, msg)
    SLOT(Qt::MessageBox.information self, title, msg)
  end

  def TicTacToe.start
    TicTacToe.new
  end
end

TicTacToe.start