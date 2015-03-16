require 'rubygems'
require 'continuation'

class BProgram

  attr_accessor :arbiter, :bthreads, :le,
                :in_pipe, :out_pipe, :emitq,
                :cont, :return_cont

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
    resume_bthreads
    delete_finished_bthreads
    # p "checking if all bthreads finished"
    if bthreads.empty?
      p "all finished!"
      push_out_pipe
      @return_cont.call
    end
    # p "not all finished"
    arbiter.next_event
    @le = arbiter.next_event
    if !@le && !@in_pipe.empty?
      @le = @in_pipe.shift
    end
    if (@le)
      bp_loop
    else
      push_out_pipe
      # p "waiting for external event..."
      @return_cont.call
    end
  end

  def resume_bthreads
    bthreads.each do |bt|
      wait = bt.wait.include? @le
      # p "%s : %s in req+wait?" % [bt.inspect, @le.inspect]
      req = bt.request.include? @le
      if req || wait
        # p "resuming %s " % bt.inspect
        resume bt, @le
      end
    end
  end

  def push_out_pipe
    while !@emitq.empty? do
      ev = @emitq.shift
      p "emitting #{ev.inspect}"
      @out_pipe.push ev
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
    # p "returned to caller..."
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
      # p "%s asked for %s" %[bt.inspect, bt.request.inspect]
      requested.concat Array(bt.request)
    end
    if requested.empty?
      # p "nothing was requested"
      return []
    end
    requested.uniq!
    bthreads.each do |bt|
      requested.delete_if { |ev|
        del = bt.block.include? ev
        # p "%s blocks %s" %[bt.inspect, ev.inspect] if del
        del
      }
    end
    # added in_pipe drawing to implicitly trigger the external events
    # without the need to artificially check for them
    requested || @in_pipe.shift
  end

end
