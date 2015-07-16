require 'spec_helper'

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
    expect(@uri).not_to be_empty
    expect(@uri).to equal( %r{ ^([0-9]{1,3}\.){1,3}[0-9]$ } )
  end

  context "proper IP generation 6" do
    skater.ip_generate(6)
    expect(@uri).not_to be_empty
    #specify { skater.ip_generate.should_return(:int)  }
  end

  context "time generation" do
    skater.create_time
    specify { skater.create_time.should_return(:string) }
end
