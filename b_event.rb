class BEvent

  attr_reader :name

  def initialize(name='BEvent')
    @name = name
  end

  def inspect
    name
  end
end