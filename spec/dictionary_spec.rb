# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect::Dictionary, '' do
  it '' do
    QRSelect::Dictionary.open do |dic|
      p dic.en_to_ja 'Cronus'
    end
  end
end
