require 'shoes'

class TicTacToeBoard

  def initialize
    @gui = Shoes.app(title: "Tic Tac Toe",
                     width: 200, height: 200,
                     resizable: false) do
      background black
      fill white
      rect 10, 350, 350
    end
  end
end