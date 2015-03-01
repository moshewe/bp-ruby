require 'Qt4'

class TicTacToeBoard

  attr_accessor :board, :gui

  def initialize
    @board = Hash.new 0
    @gui = Qt::Application.new(ARGV) do
      Qt::Widget.new do

        self.window_title = 'BP TicTacToe'

        quitb = Qt::PushButton.new('Quit') do
          connect(SIGNAL :clicked) { Qt::Application.instance.quit }
        end

        # label = Qt::Label.new('<big>Hello Qt in the Ruby way!</big>')

        xbuts = (0..2).map { |i|
          (0..2).map { |j|
            but = Qt::PushButton.new("(#{i},#{j})") do
              connect(SIGNAL :clicked) {
                but.setText 'X'
                ttt.board[[i, j]] = 'X'
                puts "val for (#{i},#{j}) is X"
              }
            end
          }
        }.flatten

        grid = Qt::GridLayout.new
        for i in 1..3 do
          for j in 1..3 do
            grid.add_widget xbuts.shift, i, j
          end
        end
        # grid.set_contents_margins(0, 0, 0, 0)
        grid.set_spacing 0

        # board_layout = Qt::HBoxLayout.new
        # 3.times {
        #   col_layout = Qt::VBoxLayout.new
        #   3.times { col_layout.add_widget(xbuts.shift, 0, Qt::AlignCenter) }
        #   board_layout.add_layout col_layout
        # }

        self.layout = Qt::VBoxLayout.new do
          # add_widget(label, 0, Qt::AlignCenter)
          addLayout grid
          add_widget(quitb, 0, Qt::AlignRight)
        end

        # self.layout.set_contents_margins(0, 0, 0, 0)

        show
      end
    end
  end

end

# ttt = TicTacToeBoard.new
# ttt.gui.exec