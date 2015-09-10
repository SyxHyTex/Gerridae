require_relative 'spec_helper'

describe Gerridae do
  extend Helpers
  subject(:skater) { Gerridae.new }

  # todo Abstract object initialization tests to shared_spec?
  describe '#initialize' do
    context 'when a Gerridae is created' do

      it 'increments instance count by 1' do
        expect{Gerridae.new}.to change(Gerridae, :count).by(1)
      end
    end
  end

  describe '#probe' do
    context 'when URI is supplied' do 
     let(:uri) { "not a uri" }

      it 'rejects non-URI objects' do
      	expect { skater.probe(uri) }.to raise_error URI::InvalidURIError 
      end
    end

    context 'when URI is not supplied' do
      let(:uri) { nil }

      it 'rejects lack of URI' do
	      expect { skater.probe(uri) }.to raise_error ArgumentError
      end

    end  

    context 'when valid URI is supplied' do
      let(:uri) { 'http://www.google.com' }

      it 'expands content array by 1 or more' do
        expect { skater.probe(uri) }.to change{ skater.content.size }.by(a_value > 0)
      end
    end

    context 'when valid response is passed' do
      let(:uri) { "http://yahoo.com" }

      before(:each) do
        skater.probe(uri)
      end
      
      it 'prevents nil header tags and elements from being written.' do
        expect(skater.content.all?).to eq true
      end
    end
  end

  describe '#form_file' do
    context 'when valid content exists' do
      let(:filename) { Helpers::create_filename(skater.uri)  }

      before(:each) do
        skater.probe('http://www.google.com')
      end

      it 'alters @file object state' do
        skater.form_file
        expect(skater).to have_attributes(:file => filename) 
      end

      it 'returns an appropriate file name' do
        skater.form_file
        expect( skater.file ).to eq filename
      end

      it 'successfully writes to file' do 
        expect{ skater.form_file }.to change{ skater.file.size }.by(a_value > 0)
      end

      it 'creates a non nil file hash' do
        expect(skater.content.all?).to eq true 
      end
    end
    context 'when invalid data is passed' do
      before (:each) do
        skater.uri = 'ksdmaspdj<F10>0Jdsdsapjdpao'
      end 
      it 'rejects nonexistant URI' do
        skater.uri = nil
        expect{skater.form_file}.to raise_error(URI::InvalidURIError)  
      end        

      it 'rejects invalid URI' do
        expect{skater.form_file}.to raise_error(URI::InvalidURIError)  
      end        
      
      # Bypasses raised errors through rescue nil to test if the method changes parameters.
      it 'does not form a filename' do
        expect{ skater.form_file rescue nil }.not_to change(skater, :file) 
      end        
      # todo 
      it 'does not write a file' do
        expect{ skater.form_file rescue nil }.not_to change(skater, :file) 
      end        
    end	
  end
end
