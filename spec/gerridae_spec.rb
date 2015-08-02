require_relative 'spec_helper'

describe Gerridae do
  subject(:skater) { Gerridae.new }

  describe '#initialize' do
    context 'when a Gerridae is created' do

      it 'increments instance count by 1' do
        expect{Gerridae.new}.to change(Gerridae, :count).by(1)
      end
    end
  end


  describe "#ip_generate" do
    context "when IP generation occurs" do

      it 'prevents non IPv4/6 generation' do
	expect { skater.ip_generate(5) }.to raise_error ArgumentError
      end 

      it "generates correct IPv4" do
	skater.ip_generate(4) { should .match %r{^([0-9]{1,3}\.){3}[0-9]{1,3}$} }
      end
      
      it 'generates correct IPv6' do
	skater.ip_generate(6) { should .match %r{^([0-9]{1,3}\.){5}[0-9]{1,3}$} }
      end
    end
  end

  describe '#parse_time' do
    context 'when time is generated' do

      it 'generates time as a string' do
	skater.parse_time {should be_an_instance_of String }
      end
    end
  end

  describe '#is_good_http_response?' do
    context 'when HTTP code is supplied' do
      
      it 'denies invalid HTTP codes' do
	expect { skater.is_good_http_response?(662) }.to raise_error RangeError 
	expect { skater.is_good_http_response?(:purple) }.to raise_error ArgumentError 
      end
    end 
  
    context 'when HTTP code is tested' do

      it 'reports failed HTTP codes' do
	expect(skater.is_good_http_response?(504)).to be false
      end 

      it 'recognizes valid HTTP codes' do
	(200..208).each do |code|
	  expect ( skater.is_good_http_response?(code) )
	end
      end
    end
  end

  describe '#probe' do
    context 'when URI is supplied' do 
      before('rejects_non-URI_objects') { @uri = "invalid uri" }
      
      it 'rejects non-URI objects' do
	expect { skater.probe(@uri) }.to raise_error URI::InvalidURIError 
      end
    end

    context 'when URI is not supplied' do
      before(:each) { @uri = nil }

      it 'rejects lack of URI' do
	expect { skater.probe(@uri) }.to raise_error ArgumentError
      end

    end  

    context 'when valid URI is supplied' do
      before(:each)  { @uri = "http://www.google.com"  }

      it 'expands content array by 1 or more' do
	expect { skater.probe(@uri) }.to change{ skater.content.size }.by( a_value > 0)
      end

    end

    context 'when valid response is passed' do
      before(:each) do
       	@uri = "http://yahoo.com"
	skater.probe(@uri)
      end
      
      it 'prevents nil header tags and elements from being written.' do
	expect(skater.content.all?).to be_truthy
      end

    end
  end

  describe '#form_file' do
    context 'when valid data is passed' do
      before do
        skater.uri = 'yahoo.com'
      end

      it 'forms appropriate file name' do
	now = Time.now
	filename = @uri.to_s + '_' + (now.to_s[0..9] + '_' + now.to_s[14..18]).to_s
	skater.form_file
	expect(skater.file).to eq(filename)
      end

      it 'forms valid file data' do
        #TODO: Load pre-made HTTP response asset for test independence.
      end
    end
    context 'when valid data is not passed' do
      
    end	
  end
end
