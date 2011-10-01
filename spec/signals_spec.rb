require 'helper'

describe Upoj::Signals do
  before :each do
    Upoj::Signals.clear
  end

  describe "#trap" do
    it "should return false if no blocks are registered" do
      Upoj::Signals.trap.should == false
    end

    it "should return true if any block is registered" do
      Upoj::Signals.on(0){}
      Upoj::Signals.trap.should == true
    end
  end

  describe "#on" do
    it "should register all given blocks in order" do
      result = String.new
      Upoj::Signals.on(0){ result << 'a' }
      Upoj::Signals.on(0){ result << 'b' }
      Upoj::Signals.on(0){ result << 'c' }
      Upoj::Signals.send :run, 0
      result.should == 'abc'
    end

    it "should register all given blocks for known signals" do
      result = String.new
      Upoj::Signals.on(1){ result << 'a' }
      Upoj::Signals.on(2){ result << 'b' }
      Upoj::Signals.on(3){ result << 'c' }
      Upoj::Signals.send :run, 1
      Upoj::Signals.send :run, 2
      Upoj::Signals.send :run, 3
      result.should == 'abc'
    end

    it "should not execute blocks whose signal was not trapped" do
      result = String.new
      Upoj::Signals.on(1){ result << 'abc' }
      Upoj::Signals.on(2){ result << 'def' }
      Upoj::Signals.send :run, 1
      result.should == 'abc'
    end

    it "should raise an ArgumentError for unknown signals" do
      [ nil, false, true, Object.new, :random, 'foo', 'BAR' ].each do |sig|
        lambda{ Upoj::Signals.on(sig){} }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#on_success" do
    it "should execute registered blocks on successful exit" do
      result = String.new
      Upoj::Signals.on_success{ result << 'abc' }
      Upoj::Signals.send :run, 0
      result.should == 'abc'
    end

    it "should not execute registered blocks on failure" do
      result = String.new
      Upoj::Signals.on_success{ result << 'abc' }
      (1..255).each do |sig|
        Upoj::Signals.send :run, sig
      end
      result.should be_empty
    end
  end

  describe "#on_failure" do
    it "should execute registered blocks on failure" do
      result = String.new
      Upoj::Signals.on_failure{ result << 'a' }
      [ 2, 3, 9, 15 ].each do |sig|
        Upoj::Signals.send :run, sig
      end
      result.should == 'aaaa'
    end

    it "should not execute registered blocks on successful exit" do
      result = String.new
      Upoj::Signals.on_failure{ result << 'abc' }
      Upoj::Signals.send :run, 0
      result.should be_empty
    end
  end

  describe "#known?" do
    it "should return true for every known signal name" do
      Signal.list.keys.each do |name|
        Upoj::Signals.known?(name).should == true
      end
    end

    it "should return true for numbers between 0 and 255" do
      (0..255).each do |n|
        Upoj::Signals.known?(n).should == true
      end
    end

    it "should return false for unknown signal names" do
      [ nil, false, true, Object.new, :random, 'foo', 'BAR' ].each do |unknown|
        Upoj::Signals.known?(unknown).should == false
      end
    end
  end

  describe "#clear" do
    it "should clear blocks for a given signal" do
      result = String.new
      Upoj::Signals.on(0){ result << 'abc' }
      Upoj::Signals.clear 0
      Upoj::Signals.send :run, 0
      result.should be_empty
    end

    it "should only clear blocks for the given signal" do
      result = String.new
      Upoj::Signals.on(1){ result << 'a' }
      Upoj::Signals.on(2){ result << 'b' }
      Upoj::Signals.on(3){ result << 'c' }
      Upoj::Signals.clear 2
      Upoj::Signals.send :run, 1
      Upoj::Signals.send :run, 2
      Upoj::Signals.send :run, 3
      result.should == 'ac'
    end

    it "should clear all blocks when no signal is given" do
      result = String.new
      Upoj::Signals.on(0){ result << 'a' }
      Upoj::Signals.on(1){ result << 'b' }
      Upoj::Signals.on(2){ result << 'c' }
      Upoj::Signals.on(3){ result << 'd' }
      Upoj::Signals.clear
      Upoj::Signals.send :run, 0
      Upoj::Signals.send :run, 1
      Upoj::Signals.send :run, 2
      Upoj::Signals.send :run, 3
      result.should be_empty
    end

    it "should not raise an error for unknown signals" do
      [ nil, false, true, Object.new, :random, 'foo', 'BAR' ].each do |sig|
        lambda{ Upoj::Signals.clear(sig){} }.should_not raise_error(ArgumentError)
      end
    end
  end
end
