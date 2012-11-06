# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect do
  it '結果を取得するたびにブロックを評価' do
    QRSelect.fetch('イラク jca', :recursive => true, :limit => 2) do |result|
      p result.to_hash.to_json
    end  
  end
end
