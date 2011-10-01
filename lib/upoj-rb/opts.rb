require 'optparse'
require 'paint'

module Upoj

  class Opts < OptionParser
    attr_accessor :funnel

    def self.section_title title
      Paint[title, :bold]
    end

    def self.section_title_ref ref
      Paint[ref, :underline]
    end

    def initialize *args
      options = args.extract_options!

      @funnel = options[:funnel] || {}
      @footer = options[:footer]
      @examples = options[:examples]

      width = options[:width] || 32
      indent = options[:indent] || (' ' * 2)
      super nil, width, indent

      @banner = options[:banner].kind_of?(Hash) ? summary_banner_section(options[:banner]) : options[:banner]
    end

    def on *args
      if block_given?
        super(*args)
      else
        sw = make_switch(args)[0]
        name = sw.long.first.sub /^\-+/, ''
        block = lambda{ |val| @funnel[name] = val }
        super(*args, &block)
      end
    end

    def summary_banner_section *args
      options = args.extract_options!
      %|#{summary_program_name} #{options[:description]}

#{self.class.section_title :USAGE}
#{@summary_indent}#{summary_program_name} #{options[:usage]}

#{self.class.section_title :OPTIONS}
|
    end

    def summary_examples_section
      return nil unless @examples
      String.new("\n#{self.class.section_title :EXAMPLES}").tap do |s|
        @examples.each do |example|
          s << "\n#{@summary_indent}#{summary_program_name} #{example}"
        end
      end
    end

    def program_name
      @program_name || File.basename($0)
    end

    def summary_program_name
      Paint[program_name, :bold]
    end

    def parse_or_exit!
      begin
        parse!
      rescue Exception => err
        unless err.kind_of?(SystemExit)
          puts
          Kernel.warn Paint["Error: #{err.message}", :yellow]
          puts
          puts self
          exit 2
        else
          exit err.status
        end
      end
    end

    def to_s
      "#{super}#{summary_examples_section}#{@footer}"
    end

    def help!
      self.on('-h', '--help', 'show this help and exit'){ puts self; exit 0 }
    end

    def usage!
      self.on('-u', '--usage', 'show this help and exit'){ puts self; exit 0 }
    end
  end
end
