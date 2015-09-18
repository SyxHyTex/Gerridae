require_relative 'spec_helper'

describe Helpers do

  let(:dummy_class) { Class.new { include Helpers  }  }
  subject(:skater) {  }


  describe "#create_filename" do
    context "" do

    end
  end

  describe "#ip_generate" do
    let(:bad_ip_v) { 5 }
    let(:not_ip_v) { 'jsiodjasipd' }

    context "when improper IP version given" do

      it "raises an error" do
        expect { Helpers::ip_generate(bad_ip_v) }.to raise_error ArgumentError
        expect { Helpers::ip_generate(not_ip_v) }.to raise_error ArgumentError
      end 
    end

    context "when IP version 4 is given" do
      let(:result) { Helpers::ip_generate(4) }

      it "generates correctly formatted IP" do
        expect(result).to match_regex %r{^([0-9]{1,3}\.){3}[0-9]{1,3}$}
      end
    end
    
    context "when IP version 6 is given" do
      let(:result) { Helpers::ip_generate(6) }

      it "generates correctly formatted IP" do
        expect(result).to match_regex %r{^([0-9]{1,3}\.){5}[0-9]{1,3}$}
      end
    end
  end


  describe '#parse_time' do
    context 'when time is generated' do
      let(:the_given_time) { Helpers::parse_time }

      it 'generates time as a string' do
        expect(the_given_time).to be_a String
      end
    end
  end

  describe '#is_good_http_response?' do
    context 'when HTTP code is supplied' do

      it 'denies invalid HTTP codes' do
        expect { Helpers::is_good_http_response?(662) }.to raise_error RangeError 
        expect { Helpers::is_good_http_response?(:purple) }.to raise_error ArgumentError 
      end
    end 
  
    context 'when HTTP code is tested' do

      it 'reports failed HTTP codes' do
	      expect(Helpers::is_good_http_response?(504)).to be false
      end 

      it 'recognizes valid HTTP codes' do
	      (200..208).each do |code|
	        expect(Helpers::is_good_http_response?(code) ).to be true
	      end
      end
    end
  end

  describe '#rename_duplicate' do
    context "when valid input is supplied" do
      let(:filename) { "http://www.yahoo.com" }
      subject(:renamed) { Helpers::rename_duplicate(filename)  }

      it "adds file number to filename" do
        expect(filename).not_to eq(renamed)
      end
    end

    context "when non-string file name given" do
      let(:filename) { Hash.new( 1 => "the", 2 => "mg") }

      it "raises exception" do
        expect{ Helpers::rename_duplicate(filename) }.to raise_error TypeError
      end
    end
  end

end
