require 'Qt4'
require_relative 'bthreads/tttb_threads'

class TicTacToe
  include TTTBThreads, TTTEvents

  attr_accessor :board, :gui,
                :program, :bthreads,
                :enforcer, :staken

  def initialize
    super
    @board = Hash.new 0
    init_gui
    init_bthreads
    h = lambda { |bps|
      case bps.program.le
        when xwin
          -1
        when owin
          1
        else
          0
      end
    }
    terminal = lambda { |bps|
      (bps.program.legal_events.include? xwin) ||
          (bps.program.legal_events.include owin)
    }
    arb = BestFirstSearchArbiter.new h, terminal
    @program = BProgram.new arb
  end

  def init_gui
    @gui = Qt::Application.new(ARGV) do
      Qt::Widget.new do

        self.window_title = 'BP TicTacToe'

        quitb = Qt::PushButton.new('Quit') do
          connect(SIGNAL :clicked) { Qt::Application.instance.quit }
        end

        butts = (0..2).map { |row|
          (0..2).map { |col|
            but = Qt::PushButton.new do
              connect(SIGNAL :clicked) {
                but.setText enforcer.current
                # board[[row, col]] = enforcer.current
                but.set_enabled false
                puts "val for (#{row},#{col}) is " + enforcer.current
                program.fire(make_move enforcer.current, row, col)
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

        self.layout = Qt::VBoxLayout.new do
          addLayout grid
          add_widget(quitb, 0, Qt::AlignRight)
        end

        show
      end
    end
  end

  def init_bthreads
    @enforcer = EnforceTurns.new
    @staken = (0..2).map { |row|
      (0..2).map { |col|
        SquareTaken.new row, col
      }
    }.flatten
    @bthreads = [DeclareWinner.new,
                 DetectDraw.new,
                 @enforcer] + DetectWin.gen_all_wins + @staken
  end

end

ttt = TicTacToe.new
ttt.gui.exec