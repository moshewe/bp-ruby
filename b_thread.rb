require 'continuation'

class BThread
  attr_accessor :request #, []
  attr_accessor :wait #, []
  attr_accessor :block #, []
  attr_accessor :cont #, nil
  #set-able in constructor
  attr_accessor :name
  attr_accessor :program
  attr_accessor :body

  def body
    # => implement bthread body here
  end  

  def initialize(*args)
    @request = [:startevent]
    @wait = [:startevent]
    @block = []
    # puts args
    if args.is_a? Hash
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
        # puts "#{k} #{v}"
      end
    end
  end

  def bsync(args = {})
    @request = args[:request]
    @wait = args[:wait]
    @block = args[:block]
    e = callcc do |cc|
      @cont=cc
      p self.inspect + " bsyncing %s, %s, %s" % [@request.inspect,
                                                 @wait.inspect,
                                                 @block.inspect]
      sleep(1)
      # call the program's cont
      @program.bsync
    end
    e # program calls cont with triggered event
  end

  def resume(le)
    if @cont.nil?
      body
    else
      @cont.call le
    end
  end

  def inspect
    if @name
      @name
    else
      self.class.name + self.hash.inspect
    end
  end
end
