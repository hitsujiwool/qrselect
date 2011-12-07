# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Main, '' do

  ## QRSelect.fetchはQRSelect::Main#fetchの短縮版

  it '結果を取得するたびにブロックを評価' do
    QRSelect.fetch('コロンビア 麻薬', :limit => 5, :expand => true) do |result|
      puts '========================================'
      puts result.seed.url
      puts result.seed.title
      puts '========================================'
    end
  end
end
