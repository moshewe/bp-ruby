require 'continuation'

@cont
@copy_cont
@returncont = nil

def moo
  i = 0
  val = callcc do |cc|
    @cont = cc
    return
  end
  return if 9 < i
  i+=1
  puts i
  if val == :copy
    callcc do |cc|
      @copy_cont = cc
      @returncont.call
    end
    @cont.call
  end
end

moo
callcc do |cc|
  @returncont = cc
  @cont.call :copy
end
@copy_cont.call