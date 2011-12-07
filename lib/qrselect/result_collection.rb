# -*- coding: utf-8 -*-
require 'delegate'

module QRSelect
  class ResultCollection < Delegator
    @checked = {}

    def initialize(keyword, engine, recursive = true)
      seed_urls = []
      ## きりがないのと、後ろの方の検索結果ではキーワードとの関連性が薄れてしまうので、とりあえず200件のみを調査する
      engine_enum = engine.new.to_enum(keyword, 200)
      @enum = Enumerator.new do |y|
        loop do
          seed_urls << engine_enum.next if seed_urls.empty?
          url_info = seed_urls.shift
          ## もしチェック済みならスキップ
          next if ResultCollection.checked?(url_info[:url])
          begin
            text = Text.new(url_info[:url], :title => url_info[:title])
          rescue
            next
          else
            result = Result.new(text)
            ResultCollection.check(text.url)
            text.extract_links.each do |url|
              begin
                candidate_text = Text.new(url)
              rescue
                next
              else
                result.candidates << candidate_text if candidate_text.english?
              end
            end
            unless result.candidates.empty?             
              ## もしrecursiveオプションが有効なら再度検索して調査対象を拡大
              ## きりがないので、1回のリクエストで取得できる検索結果の最大値(50)しか追加しない
              seed_urls.push(*engine.new.search(keyword + " site:#{text.domain}")) if recursive
              y << result
            end
          end
        end
      end
    end

    def __getobj__
      @enum
    end
    
    private 

    def self.check(url)
      @checked[url] = true
    end
    
    def self.checked?(url)
      @checked.key?(url)
    end
  end
end
