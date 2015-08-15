require 'rspec/expectations'
require 'spec_helper'

RSpec::Matchers.define :match_regex do |expected|
  match do |actual|
    expected =~ actual.to_s
  end

  failure_message do |actual|
    "expected that '#{actual}' would match the regex of #{expected.inspect}"
  end

  def supports_block_expectations?
    true
  end
end

RSpec.describe "wow" do

  it "should match simple wow regex" do
    expect("wow").to match_regex(/wow/)   
  end

  it "should not match simple mom regex" do
    expect("wow").to_not match_regex(/mom/)   
  end
end
