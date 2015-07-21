require_relative 'spec_helper'

describe Gerridae do

  subject(:skater) { Gerridae.new }

  # Gerridae#ip_generate
  it "won't allow non IPv4/6 generation" do
    expect { skater.ip_generate(5) }.to raise_error ArgumentError
  end 

  it "generates correct IPv4" do
    skater.ip_generate(4) { should .match %r{^([0-9]{1,3}\.){3}[0-9]{1,3}$} }
  end

  it "generates correct IPv6" do
    skater.ip_generate(6) { should .match %r{^([0-9]{1,3}\.){5}[0-9]{1,3}$} }
  end
  
  # Gerridae#parse_time 
  it "generates time as a string" do
    skater.parse_time {should be_an_instance_of String }
  end

  it "denies invalid HTTP codes" do
    expect { skater.is_good_http_response?(662) }.to raise_error RangeError 
    expect { skater.is_good_http_response?(:purple) }.to raise_error ArgumentError 
  end

  # Gerridae#is_good_http_response?
  context "when HTTP codes are tested" do

    it "should report failed HTTP codes" do
      skater.is_good_http_response?(504).should be false
    end 

    it "recognizes valid HTTP codes" do
      (200..208).each do |code|
	expect ( skater.is_good_http_response?(code) )
      end
    end

  end

end
