# -*- coding: utf-8 -*-
require 'delegate'

module QRSelect
  class ResultCollection < Delegator
    @checked = {}
    
    def initialize(keyword, footprint, engine, recursive = false)
      seed_urls = []
      search_api = engine.new(Config::BING_ACCOUNT_KEY)
      search_enum = search_api.to_enum(keyword)
      count = 0
      @enum = Enumerator.new do |y|
        loop do
          ## 探索が100件を越えたら打ち切り
          break if count > 100
          seed_urls << search_enum.next if seed_urls.empty?
          url_info = seed_urls.shift
          ## もしチェック済みならスキップ
          next if footprint.visited?(url_info[:url])
          begin
            text = Text.new(url_info[:url], :title => url_info[:title])
          rescue
            next
          else
            result = Result.new(text)
            footprint.visit(text.url)
            text.extract_links.each do |url|
              begin
                candidate_text = Text.new(url)
              rescue
                next
              else
                result.candidates << candidate_text if candidate_text.english?
              end
            end
            count += 1
            y << result
            unless result.candidates.empty?             
              ## きりがないので、1回のリクエストで取得できる検索結果の最大値(50)しか追加しない
              seed_urls.push(*search_api.search(keyword + " site:#{text.domain}")) if recursive
            end
          end
        end
      end
    end

    def __getobj__
      @enum
    end    
  end
end
