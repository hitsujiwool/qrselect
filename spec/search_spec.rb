# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Search, '' do
  it '' do
    enum = QRSelect::Search::Bing.new.to_enum('コロンビア 麻薬', 50)
    p enum.take(100).count
  end
end
