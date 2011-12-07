# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Main, '' do
  it '' do
    QRSelect::Main.new.fetch('コロンビア 麻薬', :limit => 2, :expand => true) do |result|
      puts '========================================'
      puts result.seed.url
      puts result.seed.title
      puts '========================================'
    end
  end
end
