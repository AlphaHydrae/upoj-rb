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

    # extract options
    args = [ 'a', 'b', { 'c' => 'd', 'e' => 'f' } ]
    options = args.extract_options!   #=> { 'c' => 'd', 'e' => 'f' }

    # returns an empty hash if there are no options
    args = [ 'a', 'b', 'c' ]
    options = args.extract_options!   #=> {}

    # can be used to easily pass an optional hash to methods
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

* __active_support/core_ext/object/blank__

  `#blank?` and `#present?` methods to easily check
  for empty strings, arrays, hashes, etc.

    ''.present?    #=> false
    ''.blank?      #=> true
    [].blank?      #=> true
    {}.blank?      #=> true
    nil.blank?     #=> true

* __active_support/core_ext/object/try__

  Allows to attempt to call a method on an object
  and not throw an error if it's nil.

    s = 'FUBAR'
    s.try :downcase   #=> 'fubar'
    s = nil
    s.try :downcase   #=> nil

* __active_support/core_ext/string/inflections__

  Useful string transformations.

    'Module1::Module2::MyClass'.demodulize   #=> 'MyClass'

* __paint__

  Command-line color output.

    Paint['fubar', :green]
    Paint['fubar', :bold, :underline]

## Copyright

Copyright (c) 2011 AlphaHydrae. See LICENSE.txt for
further details.

