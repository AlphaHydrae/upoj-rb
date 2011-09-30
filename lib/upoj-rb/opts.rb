require 'optparse'

module Upoj

  class Opts < OptionParser
    attr_accessor :funnel

    def on_funnel name, *args
      super(*args){ |val| (@funnel ||= Hash.new)[name] = val }
    end
  end
end
