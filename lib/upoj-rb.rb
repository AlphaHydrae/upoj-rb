require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'

dirname = File.dirname __FILE__
deps_dir = File.join dirname, 'upoj-rb'
VERSION_FILE = File.join dirname, '..', 'VERSION'

module Upoj
  VERSION = File.open(VERSION_FILE, 'r').read
end

%w( opts signals ).each{ |dep| require File.join(deps_dir, dep) }
