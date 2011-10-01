require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/object/try'

module Upoj
  
end

%w( opts signals ).each{ |dep| require File.join(File.dirname(__FILE__), 'upoj-rb', dep) }
