class StepAndSetGivenSelector < DefaultEventSelector

  attr_accessor :arbiter

  def initialize(arbiter = nil, next_selector)
    @arbiter = arbiter
    @next = next_selector
  end

  def select_event(legal)
    res = super legal
    arbiter.selector = @next
    res
  end

end