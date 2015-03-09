require 'rubygems'
require 'continuation'

class BProgram

  attr_accessor :arbiter, :bthreads, :le,
                :in_pipe, :out_pipe,
                :cont #, nil

  def initialize(arbiter)
    @le = :startevent
    @arbiter = arbiter
    @bthreads = []
    @in_pipe = []
    @out_pipe = []
    @emitq = []
  end

  def start
    p "starting program"
    callcc do |cc|
      @return_cont = cc
      bp_loop
    end
  end

  def bp_loop
    p "BP loop!"
    bthreads.each do |bt|
      resume_if_le_in_reqwait(bt)
    end

    delete_finished_bthreads

    p "checking if all bthreads finished"
    if bthreads.empty?
      p "all finished!"
      push_out_pipe
      @return_cont.call
    end
    p "not all finished"

    arbiter.next_event

    @le = arbiter.next_event
    if !@le && !@in_pipe.empty?
      @in_pipe.shift
    end

    if (@le)
      bp_loop
    else
      push_out_pipe
      p "waiting for external event..."
      @return_cont.call
    end
  end

  def push_out_pipe
    while !@emitq.empty? do
      ev = @emitq.shift
      p "emitting #{ev.inspect}"
      @out_pipe.push ev
    end
  end

  def resume_if_le_in_reqwait(bt)
    wait = bt.wait.include? @le
    p "%s : %s in req+wait?" % [bt.inspect, @le.inspect]
    req = bt.request.include? @le
    if req || wait
      p "resuming %s " % bt.inspect
      resume bt, @le
    end
  end

  def delete_finished_bthreads
    bthreads.delete_if do |bt|
      liveness = !bt.alive?
      if (liveness)
        p "deleted bthread " + bt.inspect
      end
      liveness
    end
  end

  def fire(ev)
    if @in_pipe.empty?
      @le = ev
      callcc do |cc|
        @return_cont = cc
        bp_loop
      end
    else
      @in_pipe.push ev
    end
  end

  def back_to_caller
    push_out_pipe
    p "waiting for external event..."
    @return_cont.call
  end

  def emit(ev)
    p "added #{ev.inspect} to emitq"
    @emitq.push ev
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

  # legal events to trigger can only be req&&!block
  def legal_events
    requested = []
    bthreads.each do |bt|
      p "%s asked for %s" %[bt.inspect, bt.request.inspect]
      requested.concat Array(bt.request)
    end
    if requested.empty?
      p "nothing was requested"
      return []
    end
    requested.uniq!
    bthreads.each do |bt|
      p "%s blocks %s" %[bt.inspect, bt.block.inspect]
      requested.delete_if { |ev|
        bt.block.include? ev
      }
    end

    requested
  end

end
