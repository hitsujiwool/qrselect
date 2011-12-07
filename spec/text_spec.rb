# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Text, '' do
  before(:all) do
    QRSelect::Config.load
  end

  it '英語と判定する' do
    QRSelect::Text.new(open('http://colombiajournal.org/clinton-revises-colombia-drug-history.htm')).english?.should be_true
  end
  
  it '英語ではないと判定する' do
    QRSelect::Text.new('http://www.jca.apc.org/~kmasuoka/places/col101004.html').english?.should be_false
  end

  it '' do
    text = QRSelect::Text.new(open('http://www.jca.apc.org/~kmasuoka/places/col101004.html'))
    p text.extract_links
  end
end
