require 'helper'

[
  { :object => nil, :description => :nil },
  { :object => [], :description => 'Empty array' },
  { :object => {}, :description => 'Empty hash' },
  { :object => '', :description => 'Empty string' },
  { :object => ' ', :description => 'Whitespace string' },
  { :object => false, :description => :false }
].each do |item|

  describe item[:description] do
    it "should be blank?" do
      item[:object].blank?.should == true
    end

    it "should not be present?" do
      item[:object].present?.should == false
    end
  end
end
