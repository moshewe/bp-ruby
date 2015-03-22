require_relative 'search_arbiter'

class MinimaxArbiter < AdversarialSearchArbiter

  def search(node)
    @depth = 0
    action = nil
    val = -Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each do |ev|
      puts "MINIMAX EXPLORING #{ev.inspect} at depth=#{@depth}"
      child = node.apply ev
      ev_val = min(child)
      @depth-=1
      if val < ev_val
        action = ev
        val = ev_val
      end
      node.restore
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect} at depth=#{@depth}"
    end
    action
  end

  def min(node)
    @depth+=1
    return h.call(node) if terminal? node
    val = Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect} at depth=#{@depth}"
      # if @depth == 1 || @depth ==3
      #   puts 'moomoo'
      # end
      child = node.apply ev
      maxval = max(child)
      @depth-=1
      val = [val, maxval].min
      node.restore
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect} at depth=#{@depth}"
      # GC.start
    }
    val
  end

  def max(node)
    @depth+=1
    return h.call(node) if terminal? node
    val = -Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect} at depth=#{@depth}"
      # if @depth == 2
      #   puts 'moomoo'
      # end
      child = node.apply ev
      minval = min(child)
      val = [val, minval].max
      @depth-=1
      node.restore
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect} at depth=#{@depth}"
      # GC.start
    }
    val
  end

end