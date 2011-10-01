# upoj-rb

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

## Improved Option Parser

Customized version of ruby's [OptionParser](http://ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html).

### Funnel

By default, all options that are defined without a block can
be retrieved with `#funnel`.

    # define your options
    opts = Upoj::Opts.new
    opts.on('--option'){ # do whatever }
    opts.on('-f', '--fubar')
    opts.on('-v', '--value VALUE')

    # parse
    ARGV          #=> [ '--option', '-f', '--value', '43' ]
    opts.parse!

    # retrieve options in funnel by default
    opts.funnel   #=> { 'fubar' => true, 'value' => 43 }

The funnel can be given at construction with initial values.

    # starting funnel
    funnel = { 'foo' => false }

    # define your options
    opts = Upoj::Opts.new :funnel => funnel
    opts.on('-f', '--fubar')

    # parse
    ARGV          #=> [ '--fubar' ]
    opts.parse!

    # retrieve the funnel with initial and new options
    opts.funnel   #=> { 'foo' => false, '--fubar' => true }

### Structured Banner

A hash can be given for the banner.

    banner = {
      :usage => '[OPTION]... ARG1 ARG2',
      :description => 'does stuff with ARG1 and ARG2.'
    }

    opts = Upoj::Opts.new :banner => banner
    opts.on('-f', '--fubar', 'do something awful')
    
    # the generated banner will look like this,
    # with USAGE, OPTIONS and my_script in bold

    my_script does stuff with ARG1 and ARG2.

    USAGE
      my_script [OPTION]... ARG1 ARG2

    OPTIONS
      -f, --fubar                      do something awful

### Help and Usage

Automatically register `-h`, `--help`, `-u` and `--usage` switches
with `#help!` and `#usage!`.

    opts = Upoj::Opts.new

    # you can replace this:
    opts.on('-u', '--usage', 'show this help and exit'){ puts opts; exit 0 }

    # by this:
    opts.usage!

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

