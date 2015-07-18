require_relative 'spec_helper'

describe Gerridae do

  let(:skater) { Gerridae.new }

  it "won't allow non IPv4/6 generation" do
    expect { skater.ip_generate(5) }.to raise_error ArgumentError
  end 

  it "generates correct IPv4" do
    skater.ip_generate(4) { should .match %r{^([0-9]{1,3}\.){3}[0-9]{1,3}$} }
  end

  it "generates correct IPv6" do
    skater.ip_generate(6) { should .match %r{^([0-9]{1,3}\.){5}[0-9]{1,3}$} }
  end
  it "generates time as a string" do
    skater.parse_time {should  eq :string }
  end
end
