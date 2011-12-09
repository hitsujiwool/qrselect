# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::ResultCollection, '' do
  it '' do
    collection = QRSelect::ResultCollection.new('コロンビア 麻薬', QRSelect::Search::Bing)
    collection.take(2).each do |result|
      puts result.seed.title
      puts result.seed.url
    end
  end
end
