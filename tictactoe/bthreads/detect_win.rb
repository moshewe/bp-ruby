require_relative '../../b_thread'
require_relative '../ttt_events'

class DetectWin < BThread
  include TTTEvents

  attr_accessor :win_event, :first, :second, :third

  def initialize(winevent, first, second, third)
    BThread.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    @name = "DetectWin(#{winevent.inspect},#{first.inspect},#{second.inspect},#{third.inspect})"
    @win_event = winevent
    @first = first
    @second = second
    @third = third
  end

  def body(le)
    bsync({:request => none,
           :wait => @first,
           :block => none})
    bsync({:request => none,
           :wait => @second,
           :block => none})
    bsync({:request => none,
           :wait => @third,
           :block => none})
    bsync({:request => @win_event,
           :wait => none,
           :block => [event_of_class(Move),
                      TTTEvents.draw]})
    program.emit @win_event
  end

  def DetectWin.gen_all_wins
    # All 6 permutations of three elements
    permutations = [[0, 1, 2], [0, 2, 1], [1, 0, 2],
                    [1, 2, 0], [2, 0, 1], [2, 1, 0]]

    x_row_wins = (0..2).flat_map do |row|
      permutations.map do |p|
        DetectWin.new TTTEvents.xwin, X.new(row, p[0]),
                      X.new(row, p[1]),
                      X.new(row, p[2])
      end
    end

    o_row_wins = (0..2).flat_map do |row|
      permutations.map do |p|
        DetectWin.new TTTEvents.owin, O.new(row, p[0]),
                      O.new(row, p[1]),
                      O.new(row, p[2])
      end
    end

    row_wins = x_row_wins + o_row_wins

    x_col_wins = (0..2).flat_map do |col|
      permutations.map do |p|
        DetectWin.new TTTEvents.xwin, X.new(p[0], col),
                      X.new(p[1], col),
                      X.new(p[2], col)
      end
    end

    o_col_wins = (0..2).flat_map do |col|
      permutations.map do |p|
        DetectWin.new TTTEvents.owin, O.new(p[0], col),
                      O.new(p[1], col),
                      O.new(p[2], col)
      end
    end

    col_wins = x_col_wins + o_col_wins

    x_diagonal_wins = permutations.map do |p|
      DetectWin.new TTTEvents.xwin, X.new(p[0], p[0]),
                    X.new(p[1], p[1]),
                    X.new(p[2], p[2])
    end

    o_diagona_wins = permutations.map do |p|
      DetectWin.new TTTEvents.owin, O.new(p[0], p[0]),
                    O.new(p[1], p[1]),
                    O.new(p[2], p[2])
    end

    main_diagonal_wins = x_diagonal_wins + o_diagona_wins

    x_inverse_diagonal_wins = permutations.map do |p|
      DetectWin.new TTTEvents.xwin, X.new(p[0], 2 - p[0]),
                    X.new(p[1], 2 - p[1]),
                    X.new(p[2], 2 - p[2])
    end

    o_inverse_diagonal_wins = permutations.map do |p|
      DetectWin.new TTTEvents.owin, O.new(p[0], 2 - p[0]),
                    O.new(p[1], 2 - p[1]),
                    O.new(p[2], 2 - p[2])
    end
    inverse_diagonal_wins = x_inverse_diagonal_wins +
        o_inverse_diagonal_wins

    row_wins + col_wins + main_diagonal_wins + inverse_diagonal_wins
  end
end


