# -*- coding: utf-8 -*-
require 'optparse'

module QRSelect
  module Exec
    def self.run
      params = {}

      opt = OptionParser.new

      ## 検索結果
      opt.on('-n NUMBER OF RESULTS', Integer) do |v|
        params[:limit] = v
      end

      ## キーワード拡張
      opt.on('-e EXPAND KEYWORDS') do
        params[:expand] = true
      end

      ## 対訳が見つかったページのドメインを沿えて再検索
      opt.on('-r RECURSIVE') do
        params[:recursive] = true
      end

      ## ドメイン指定
      opt.on('-d DOMAIN', String) do |v|
        params[:domain] = v
      end

      if ARGV.empty?
        $stdout.puts 'Please input keywords!'        
      else
        keyword = ARGV.first
        if keyword[0] === '-'
          $stdout.puts 'Please input keywords!'        
        else
          keyword = ARGV.shift
          opt.parse!(ARGV)
          Main.new.fetch(keyword, params)
        end
      end
    end
  end
end
