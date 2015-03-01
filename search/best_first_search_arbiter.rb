require_relative '../bp'

class BestFirstSearchArbiter < Arbiter

  attr_accessor :h
  attr_accessor :terminal_func

  def initialize(h, terminal_func)
    @h = h
    @terminal_func = terminal_func
  end

  def terminal?(node)
    terminal_func node
  end

  def search(root)
    openlist = [root]
    while (!openlist.empty?)
      best = openlist.pop
      if terminal? best then
        return best.actions.first
      end
      openlist.concat best.expand
      openlist.sort_by { |n| h(n) }
    end
    nil
  end

  def select_event(legal=[])
    root = SearchNode.new(program)
    sol = search(root)
    sol.actionlist.first
  end

end