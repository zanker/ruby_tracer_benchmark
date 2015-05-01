require 'benchmark'
require 'coverband'
require 'coverband_ext'
require './coverband_base.rb'
require './test_case.rb'

ITERATIONS = 100
Benchmark.bm do |x|
  x.report("base") do
    ITERATIONS.times do
      TestCase.new.test_aa(1, 2, 3)
    end  
  end

  # Coverband gem
  x.report("Coverband + Ext") do
    ITERATIONS.times do
      Coverband::Base.instance.start
      TestCase.new.test_aa(1, 2, 3)
      Coverband::Base.instance.stop
    end
  end
  
  # set_trace_func is an old style that's inefficient
  set_trace_func proc { |event, file, line, id, binding, classname| }
  
  x.report("trace_func") do
    ITERATIONS.times do
      TestCase.new.test_aa(1, 2, 3)
    end
  end
  
  set_trace_func nil
  
  # TracePoint lets us subscribe to a subset we care about
  trace = TracePoint.new(:call) do |tp|
  end
  
  trace.enable
  
  x.report("TracePoint") do
    ITERATIONS.times do
      TestCase.new.test_aa(1, 2, 3)
    end
  end
  
  trace.disable
end
