# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Text, '' do
  it '英語と判定する' do
    QRSelect::Text.new('http://colombiajournal.org/clinton-revises-colombia-drug-history.htm').english?.should be_true
  end
  
  it '英語ではないと判定する' do
    QRSelect::Text.new('http://www.jca.apc.org/~kmasuoka/places/col101004.html').english?.should be_false
  end

  it '原文へのリンクを抽出' do
    text = QRSelect::Text.new('http://www.jca.apc.org/~kmasuoka/places/col101004.html')
    text.extract_links.length.should eq(1)
  end

  it '対訳スコアの判定' do
    ja_text = QRSelect::Text.new('http://www.jca.apc.org/~kmasuoka/places/col101004.html')
    en_text = QRSelect::Text.new('http://colombiajournal.org/clinton-revises-colombia-drug-history.htm')
    ja_text.score_to(en_text)
  end
end
