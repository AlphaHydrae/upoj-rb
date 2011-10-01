require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'

module Upoj
  
end

%w( opts signals ).each{ |dep| require File.join(File.dirname(__FILE__), 'upoj-rb', dep) }
