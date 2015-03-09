class DefaultEventSelector

  attr_accessor :arbiter

  def initialize(arbiter = nil)
    @arbiter = arbiter
  end

  def select_event(legal)
    legal.sample
  end

end