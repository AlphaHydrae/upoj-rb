module Upoj
  
end

%w( ext opts signals ).each{ |dep| require File.join(File.dirname(__FILE__), 'upoj-rb', dep) }
