require 'test/unit'
require_relative 'bp'

class BpTest < Test::Unit::TestCase

  def setup
    $line = []
    arb = Arbiter.new
    @prog = BProgram.new arb
    arb.program = @prog
  end

  # class TestSanity < BpTest
  #   def test_add_run_bt
  #     bt = BThread.new do |e|
  #       p "printing hello to line"
  #       $line << "hello!"
  #     end
  #
  #     @prog.bthreads.push bt
  #     @prog.start
  #     assert_equal ["hello!"], $line, "bthread didn't print hello!"
  #   end
  # end

  class Tap1 < BThread

    def initialize(*args)
      name = "Tap1"
      program = @prog
      super args
    end

    def body
      p "bt1 started!"
      sleep(2)
      for i in 1..3 do
        bsync(:request => [:e1],
              :wait => [],
              :block => [])
        p 1
        sleep(2)
        $line << 1
      end
    end
  end

  class Tap2 < BThread
    @name = "Tap2"
    @program = @prog

    def body
      p "bt2 started!"
      sleep(2)
      for i in 1..3 do
        bsync(:request => [:e2],
              :wait => [],
              :block => [])
        p 1
        sleep(2)
        $line << 1
      end
    end
  end

  class TestAlternator < BpTest
    def test_alternating
      bt1 = Tap1.new
      bt2 = Tap2.new
      btAlternator = BThread.new({:name => "Alternator",
                                  :program => @prog,
                                  :body => lambda {
                                    p "alternator started!"

                                    sleep(1)
                                    for i in 1..3 do
                                      p 'alternator blocking 2'
                                      sleep(1)
                                      btAlternator.bsync(:request => [],
                                                         :wait => EventSet.any,
                                                         :block => [:e2])
                                      p 'alternator blocking 1'
                                      sleep(1)
                                      btAlternator.bsync(:request => [],
                                                         :wait => EventSet.any,
                                                         :block => [:e1])
                                    end
                                    p "alternator done!"
                                  }
                                 })

      @prog.bthreads.push bt1, bt2, btAlternator
      @prog.start
      assert_equal [1, 2, 1, 2, 1, 2], $line, "bthreads must alternate"
    end
  end
end
