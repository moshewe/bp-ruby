class UpdateDisplay
  include TTTEvents

  @bodyfunc = lambda {
    while (true)
      move = bsync(
          {:request => none,
           :wait => event_of_class Move,
                                   :block => none})
      ttt.make_move move.row, move.col
    end
  }

end