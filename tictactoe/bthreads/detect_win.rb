require_relative '../../b_thread'
require_relative '../ttt_events'

class DetectWin < BThread
  include TTTEvents

  attr_accessor :win_event, :first, :second, :third

  def initialize(winevent, first, second, third)

    @win_event = winevent
    @first = first
    @second = second
    @third = third
  end

  @bodyfunc = lambda { |e|
    bsync({:request => @first,
           :wait => none,
           :block => none})
    bsync({:request => @second,
           :wait => none,
           :block => none})
    bsync({:request => @third,
           :wait => none,
           :block => none})
    bsync({:request => @win_event,
           :wait => none,
           :block => none})
  }

  def DetectWin.gen_all_wins
    # All 6 permutations of three elements
    permutations = [[0, 1, 2], [0, 2, 1], [1, 0, 2],
                    [1, 2, 0], [2, 0, 1], [2, 1, 0]]

    row_wins = (1..3).flat_map do |row|
      (permutations.map do |p|
        DetectWin.new xwin, X.new(row, p[0]),
                      X.new(row, p[1]),
                      X.new(row, p[2])
      end).concat permutations.map do |p|
        DetectWin.new owin, O.new(row, p[0]),
                      O.new(row, p[1]),
                      O.new(row, p[2])
      end
    end

    col_wins = (1..3).flat_map do |col|
      (permutations.map do |p|
        DetectWin.new xwin, X.new(p[0], col),
                      X.new(p[1], col),
                      X.new(p[2], col)
      end).concat permutations.map do |p|
        DetectWin.new owin, O.new(p[0], col),
                      O.new(p[1], col),
                      O.new(p[2], col)
      end
    end

    main_diagonal_wins = (permutations.map do |p|
      DetectWin.new xwin, X.new(p[0], p[0]),
                    X.new(p[1], p[1]),
                    X.new(p[2], p[2])
    end).concat permutations.map do |p|
      DetectWin.new owin, O.new(p[0], p[0]),
                    O.new(p[1], p[1]),
                    O.new(p[2], p[2])
    end

    inverse_diagonal_wins = (permutations.map do |p|
      DetectWin.new xwin, X.new(p[0], 2 - p[0]),
                    X.new(p[1], 2 - p[1]),
                    X.new(p[2], 2 - p[2])
    end).concat permutations.map do |p|
      DetectWin.new owin, O.new(p[0], 2 - p[0]),
                    O.new(p[1], 2 - p[1]),
                    O.new(p[2], 2 - p[2])
    end

    row_wins + col_wins + main_diagonal_wins + inverse_diagonal_wins
  end
end


