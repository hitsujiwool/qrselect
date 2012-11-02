# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Search do
  before(:all) do
    @bing = QRSelect::Search::Bing.new(QRSelect::Config::BING_ACCOUNT_KEY)
  end

  it 'should convert hash to querystring' do
    @bing.send(:hash_to_querystring, :sheep1 => 'baa', :sheep2 => 'baaaa').should == 'sheep1=baa&sheep2=baaaa'
  end
  
  it 'should fetch first 5 results' do
    @bing.search('hitsujiwool', :limit => 5).length.should == 5
  end

  it 'should fetch first 55 results' do
    @bing.search('hitsujiwool', :limit => 55).length.should == 55
  end

  describe 'Enumerator' do
    before(:all) do
      @bing = QRSelect::Search::Bing.new(QRSelect::Config::BING_ACCOUNT_KEY)
      @num_to_be_fetched = @bing.search('hitsujiwool', :limit => 99999).length
    end
    
    before(:each) do
      @bing_enum = @bing.to_enum('hitsujiwool')
    end

    it 'should fetch all results using enumerator' do
      i = 0
      loop do
        @bing_enum.next
        i += 1
      end
      i.should == @num_to_be_fetched
    end
    
    it 'should fetch first 5 results' do
      @bing_enum.take(5).length.should == 5
    end

    it 'should fetch all results' do
      @bing_enum.take(99999).length.should == @num_to_be_fetched
    end
  end
end
