require_relative 'b_thread'
require_relative 'b_program'
require_relative 'b_event'
require_relative 'arbiter'
require_relative 'event_set'

module BP

  def BP.new_bprogram
    puts 'bprogram loaded'
  end
  
end

BP.new_bprogram
