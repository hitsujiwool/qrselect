require 'qrselect/config'
require 'qrselect/dictionary'
require 'qrselect/exec'
require 'qrselect/helper'
require 'qrselect/result'
require 'qrselect/result_collection'
require 'qrselect/search'
require 'qrselect/text'
require 'qrselect/version'
require 'qrselect/main'

module QRSelect
  def self.config(params)
    if params.is_a?(String)
      Config.load(params)
    else 
      Config.init(params)
    end
  end
  
  def self.fetch(keyword, params = {}, &block)
    Main.new.fetch(keyword, params, &block)
  end
end
