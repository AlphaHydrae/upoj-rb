require 'helper'

describe Object do
  %w( blank? present? try ).each do |method|
    it{ should respond_to(method) }
  end
end

describe Array do
  it{ should respond_to(:extract_options!) }
end
