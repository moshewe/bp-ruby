class BEvent

  attr_reader :name

  def initialize(name='BEvent')
    @name = name
  end

  def inspect
    name
  end

  def include?(ev)
    self == ev
  end

  def ==(ev)
    self.name.eql? ev.name
  end
end