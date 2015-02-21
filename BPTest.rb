require 'test/unit'
require_relative 'bp'

class BpTest < Test::Unit::TestCase

  attr_accessor :prog

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

  class TestAlternator < BpTest
    class Tap1 < BThread
      def initialize(args = {})
        super ({:bodyfunc =>
                    lambda {
                      p "bt1 started!"
                      sleep(2)
                      for i in 1..3 do
                        bsync(:request => [:e1],
                              :wait => [],
                              :block => [])
                        puts 1
                        sleep(1)
                        $line << 1
                      end
                    }}.merge(args))
      end
    end

    class Tap2 < BThread
      def initialize(args={})
        super(args)
        self.bodyfunc = lambda {
          puts 'bt2 started!'
          sleep(2)
          for i in 1..3 do
            bsync(:request => [:e2],
                  :wait => [],
                  :block => [])
            puts 2
            sleep(1)
            $line << 2
          end
        }
      end
    end

    def test_alternating
      bt1 = Tap1.new({:name => "Tap1",
                      :program => @prog})
      bt2 = Tap2.new({:name => "Tap2",
                      :program => @prog})
      btAlternator = BThread.new({:name => "Alternator",
                                  :program => @prog,
                                  :bodyfunc => lambda {
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
