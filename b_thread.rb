require 'continuation'
require_relative 'base_events'

class BThread
  include BaseEvents
  attr_accessor :request #, []
  attr_accessor :wait #, []
  attr_accessor :block #, []
  attr_accessor :cont #, nil
  #set-able in constructor
  attr_accessor :name
  attr_accessor :program
  attr_accessor :bodyfunc, :alive

  def body_wrap(le)
    body le
    @alive = false
  end

  def body(le)
    bodyfunc.call le
  end

  def initialize(args = {})
    @request = [:startevent]
    @wait = [:startevent]
    @block = none
    @alive = true
    # puts args
    # if args.is_a? Hash
    args.each do |k, v|
      # p "key is #{k}, value is #{v}"
      instance_variable_set("@#{k}", v) unless v.nil?
      # p "set #{instance_variable_get("@#{k}")}"
    end
    # end
  end

  def bsync(args = {})
    @request = args[:request] || none
    @wait = args[:wait] || none
    @block = args[:block] || none
    e = callcc do |cc|
      @cont=cc
      p self.inspect + " bsyncing %s, %s, %s" % [@request.inspect,
                                                 @wait.inspect,
                                                 @block.inspect]
      # call the program's cont
      @program.bsync
    end
    if e.is_a? CopyContEvent
      e = callcc do |cc|
        e.call cc
      end
      @cont.call e
    end
    e # program calls cont with triggered event
  end

  def resume(le)
    if @cont.nil?
      body_wrap le
    else
      @cont.call le
    end
  end

  def alive?
    @alive
  end

  def state

  end

  def inspect
    if name
      name
    else
      self.class.name + self.hash.inspect
    end
  end
end
