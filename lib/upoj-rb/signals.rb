module Upoj

  # Register of blocks of code to execute when the script receives a particular signal.
  module Signals

    # Traps script signals. Blocks registered with Signals.on will be
    # executed when the script receives the corresponding status.
    #
    # Blocks previously trapped without using this class will be replaced.
    #
    # Returns true if any signals were trapped.
    def self.trap
      @@trapped.each_key{ |signal| Signal.trap(signal){ self.run signal } }
      @@trapped.any?
    end

    # Clears all blocks registered for the given signal.
    # Use nil to clear all blocks for all signals.
    #
    # No error will be raised if the signal is unknown.
    def self.clear signal = nil
      signal ? @@trapped[signal_number(signal, false)].try(:clear) : @@trapped.clear; nil
    end

    # Registers a block to be executed when the script
    # receives a given signal. This method can be called several
    # times; all registered blocks will be called in the order they
    # were registered when the signal is received. If the signal
    # is not known, ArgumentError is raised (see #known?).
    #
    # Signals.trap must be called after registering the blocks
    # for them to be activated.
    #
    # ==== Arguments
    # * <tt>signal</tt> - The signal to trap.
    # * <tt>&block</tt> - The block to execute when the signal is trapped.
    #
    # ==== Examples
    #   Upoj::CLI::Signals.on(:exit){ cleanup_temporary_files }
    #   Upoj::CLI::Signals.on("TERM"){ close_connections }
    #   Upoj::CLI::Signals.on(2) do
    #     puts usage
    #   end
    def self.on signal, &block
      (@@trapped[signal_number(signal)] ||= []) << block; block
    end

    # Blocks registered with this method will be executed if the
    # script exits with any of the following statuses: <tt>QUIT,
    # TERM, KILL, INT</tt> (2, 3, 9, 15).
    #
    # Signals.trap must be called after registering the blocks
    # for them to be activated.
    #
    # ==== Arguments
    # * <tt>&block</tt> - The block to execute when the script
    #   fails.
    #
    # ==== Examples
    #   Upoj::CLI::Signals.on_failure{ close_connections }
    def self.on_failure &block
      FAILURE_STATUSES.each{ |status| self.on status, &block }; block
    end

    # Blocks registered with this method will be executed if the
    # script exits successfully with status <tt>EXIT</tt> (0).
    #
    # Signals.trap must be called after registering the blocks
    # for them to be activated.
    #
    # ==== Arguments
    # * <tt>&block</tt> - The block to execute when the script
    #   exits successfully.
    #
    # ==== Examples
    #   Upoj::CLI::Signals.on_success{ FileUtils.rm_fr tmp }
    def self.on_success &block
      SUCCESS_STATUSES.each{ |status| self.on status, &block }; block
    end

    # Indicates whether the given signal is valid, i.e. whether
    # it is either a number or one of the text signals returned
    # by Signal#list.
    def self.known? signal
      !!signal_number(signal, false)
    end

    private

    # Returns the map of signal names and their numerical value
    # returned by Signal#list.
    def self.signals
      @@signals ||= Signal.list
    end

    # Returns the numerical value of the given signal.
    # Statuses in Signal#list can be given as text.
    def self.signal_number signal, raise_if_unknown = true
      (signal.kind_of?(Fixnum) ? signal : signals[signal.to_s.upcase]).tap do |n|
        raise ArgumentError, "Unknown signal '#{signal}'. Signal must either be a number or one of the text signals returned by Signal.list." if raise_if_unknown && !n
      end
    end

    # Runs all the blocks registered for the given signal.
    def self.run signal
      @@trapped[signal].try(:each){ |block| block.try :call, signal }
    end

    # List of exit statuses considered a termination.
    # 2 = INT, 3 = QUIT, 9 = KILL, 15 = TERM
    FAILURE_STATUSES = [ 2, 3, 9, 15 ]

    # List of exit statuses considered successful.
    # 0 = EXIT
    SUCCESS_STATUSES = [ 0 ]

    # Map of numerical exit statuses and the corresponding list of
    # blocks to execute.
    @@trapped = {}
  end
end
