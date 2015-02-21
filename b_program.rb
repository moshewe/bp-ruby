require 'rubygems'
require 'continuation'

class BProgram

  attr_accessor :arbiter, :bthreads, :le
  attr_accessor :cont #, nil

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
      if req || wait
        p "resuming %s " % bt.inspect
        sleep(1)
        resume bt, @le
      end
    end

    bthreads.delete_if do |bt|
      liveness = !bt.alive?
      if (liveness)
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

  def resume(bt, le)
    callcc do |cc|
      @cont = cc
      bt.resume le
    end
  end

  def bsync
    @cont.call
  end
end
