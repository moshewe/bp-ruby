class BEvent

  attr_reader :name

  def initialize(*name)
    @name = name if !name.nil?
  end

  def inspect
    name
  end
end