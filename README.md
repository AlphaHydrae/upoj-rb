# upoj-rb

Ruby scripting utilities.

This gem is a collection of ruby dependencies which I have found useful
for scripting, as well as a few additions to existing classes such as
OptionParser.

## Using

You can install upoj-rb on the command line:

    gem install upoj-rb

Or add it to your project's Gemfile:

    gem 'upoj-rb'

Then require and use it:

    require 'upoj-rb'
    puts Upoj::VERSION

## Included Dependencies

* __active_support/core_ext/array/extract_options__

  Extraction of hash options from the end of an array.

    def method *args
      options = args.extract_options!
    end

* __active_support/core_ext/hash/indifferent_access__

  Hash that makes no difference between strings and
  symbols as keys.

    h = HashWithIndifferentAccess.new 'a' => 'value a', :b => 'value b'
    h['a']    #=> 'value a'
    h[:a]     #=> 'value a'
    h['b']    #=> 'value b'
    h[:b]     #=> 'value b'


## Copyright

Copyright (c) 2011 AlphaHydrae. See LICENSE.txt for
further details.

