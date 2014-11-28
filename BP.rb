module BehaviouralProgramming
  require 'rubygems'
  require 'fiber'

  class Arbiter

    attr_accessor :program

    def next_event
      p "arbiting next event"
      sleep(1)
      legal = []
      program.bthreads.each do |bt|
        p "%s asked for %s " %[bt.inspect, bt.request]
        sleep(1)
        legal.concat bt.request
      end

      program.bthreads.each do |bt|
        legal.select! { |e| !bt.block.include? e }
      end

      if legal.empty?
        p "need external event, legal is empty!"
        sleep(1)
        nil
      else
        p "legal events: #{legal}"
        sleep(1)
        e = legal.sample
        p "event selected is #{e}"
        sleep(1)
        e
      end
    end
  end

  class BProgram

    attr_accessor :arbiter, :bthreads, :le

    def initialize(arbiter)
      @le = :startevent
      @arbiter = arbiter
      @bthreads = []
    end

    def start
      p "starting program"
      bp_loop
    end

    def bp_loop
      #   we resume all bthreads
      # we assume the start state is "valid":
      # bthreads are not blocking initial events
      p "bp_loop!"
      sleep(1)

      bthreads.each do |bt|
        req = bt.request.include? @le
        wait = bt.wait.include? @le
        p "%s : %s in req+wait?" % [bt.inspect, @le]
        sleep(1)
        if  req || wait
          p "resuming %s " % bt.inspect
          sleep(1)
          bt.resume @le
        end
      end

      bthreads.delete_if do |bt|
        liveness = !bt.alive?
        if(liveness)
          p "deleted bthread " + bt.inspect
          sleep(1)
        end
        liveness
      end

      p "checking if all bthreads finished"
      sleep(1)
      if bthreads.empty?
        p "all finished!"
        return
      end
      p "not all finished"
      sleep(1)

      @le = arbiter.next_event
      if (@le)
        bp_loop
      else
        if @interactive
          p "need external event!"
          gets
        else
          p "DEADLOCK!"
        end
      end
    end
  end

  class BThread < Fiber
    attr_accessor :program
    attr_accessor :request #, []
    attr_accessor :wait #, []
    attr_accessor :block #, []
    attr_accessor :cont #, nil
    attr_accessor :name

    def initialize
      @program
      @request = [:startevent]
      @wait = [:startevent]
      @block = []
      @cont
      super
    end

    def bsync(args = {})
      @request = args[:request]
      @wait = args[:wait]
      @block = args[:block]
      # callcc do |cc|
      # @restore = make_restore
      # cont=cc
      # e = @program.bsync
      p self.inspect + " bsyncing %s, %s, %s" % [@request.inspect,
                                                 @wait.inspect,
                                                 @block.inspect]
      sleep(1)
      Fiber.yield
      # restore
      # e
      # end
    end

    def inspect
      if @name
        @name
      else
        self.class.name + self.hash.inspect
      end
    end
  end

  class EventSet
    class Any
      def include?(e)
        true
      end

      def inspect
        "any"
      end
    end

    class None
      def include?(e)
        false
      end

      def inspect
        "none"
      end
    end

    @@anyEventSet = EventSet::Any.new
    @@noneEventSet = EventSet::None.new

    def self.any
      @@anyEventSet
    end

    def self.none
      @@noneEventSet
    end
  end
end
