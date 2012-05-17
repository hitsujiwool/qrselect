# -*- coding: utf-8 -*-
require 'optparse'

module QRSelect
  module Exec
    def self.run
      params = {}

      opt = OptionParser.new
      config_path = Dir.getwd + '/qrselect.conf'

      ## 検索結果
      opt.on('-n NUMBER OF RESULTS', Integer, 'Number of results (default 50)') do |v|
        params[:limit] = v
      end

      ## キーワード拡張
      opt.on('-e', 'Expand keywords (default false)') do
        params[:expand] = true
      end

      ## 対訳が見つかったページのドメインを沿えて再検索
      opt.on('-r', 'Search recursively (default false)') do
        params[:recursive] = true
      end

      ## ドメイン指定
      opt.on('-d DOMAIN', String, 'Limit domain') do |v|
        params[:domain] = v
      end

      ## 設定ファイルのパス
      opt.on('-c CONFIG FILE PATH', String, 'Path to config file') do |v|
        config_path = v
      end

      if ARGV.empty?
        $stdout.puts 'Please input keywords!'
      else
        keyword = ARGV.first
        if keyword == '-h' || keyword == '--help'
          opt.parse!(ARGV)
        elsif keyword[0] === '-'
          $stdout.puts 'Please input keywords!'
        else
          keyword = ARGV.shift
          opt.parse!(ARGV)
          Config.load(config_path)
          Main.new.fetch(keyword, params) do |result|
            next if result.candidates.empty?
            print <<EOS
========================================
jp_url:#{result.seed.url}
en_url:#{result.highest_score_text.url}
========================================
EOS
          end
        end
      end
    end
  end
end
