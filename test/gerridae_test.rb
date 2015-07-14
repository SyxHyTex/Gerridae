#Gerridae.rb test class (rspec)
require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe Gerridae do

  before_each do
    let (:skater) { Gerridae.new }
  end


  context "bad IP generation" do
    skater.ip_generate(5)
    expect { ip_generate }.to raise_error
  end

  context "proper IP generation 4" do
    skater.ip_generate(4)
    #specify { skater.ip_generate.should_return(:int)  }
  end
end
