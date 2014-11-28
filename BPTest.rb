require 'test/unit'
require_relative './BP'

class BpTest < Test::Unit::TestCase
  def setup
    $line = []
    arb = BehaviouralProgramming::Arbiter.new
    @prog = BehaviouralProgramming::BProgram.new arb
    arb.program = @prog
  end

  # class TestSanity < BpTest
  #   def test_add_run_bt
  #     bt = BehaviouralProgramming::BThread.new do |e|
  #       p "printing hello to line"
  #       $line << "hello!"
  #     end
  #
  #     @prog.bthreads.push bt
  #     @prog.start
  #     assert_equal ["hello!"], $line, "bthread didn't print hello!"
  #   end
  # end

  class TestAlternator < BpTest
    def test_alternating
      bt1 = BehaviouralProgramming::BThread.new do |e|
        p "bt1 started!"
        sleep(2)
        for i in 1..3 do
          bt1.bp_loop(:request => [:e1], :wait => [], :block => [])
          p 1
          sleep(2)
          $line << 1
        end
      end
      bt1.name="tap1"
      bt2 = BehaviouralProgramming::BThread.new do |e|
        p "bt2 started!"
        sleep(2)
        for i in 1..3 do
          bt2.bp_loop(:request => [:e2], :wait => [], :block => [])
          p 2
          sleep(2)
          $line << 2
        end
      end
      bt2.name="tap2"
      btAlternator = BehaviouralProgramming::BThread.new do |e|
        p "alternator started!"
        sleep(1)
        for i in 1..3 do
          p 'alternator blocking 2'
          sleep(1)
          btAlternator.bp_loop(:request => [],
                             :wait => BehaviouralProgramming::EventSet.any,
                             :block => [:e2])
          p 'alternator blocking 1'
          sleep(1)
          btAlternator.bsync(:request => [],
                             :wait => BehaviouralProgramming::EventSet.any,
                             :block => [:e1])
        end
        p "alternator done!"
      end
      btAlternator.name="Alternator"
      @prog.bthreads.push bt1, bt2, btAlternator

      @prog.start
      assert_equal [1, 2, 1, 2, 1, 2], $line, "bthreads must alternate"
    end
  end
end
