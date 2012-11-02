# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'net/https'

module QRSelect
  module Search
    class Base
      def to_enum(keyword, offset = 0)
        footprint = {}
        Enumerator.new do |y|
          loop do
            results = search(keyword, { :offset => offset }, footprint)
            # もし新しい結果が得られなかったらおしまい
            break if results.empty?
            results.each do |result|
              y << result
              offset += 1
            end
          end
        end      
      end

      private 

      def hash_to_querystring(hash)
        tmp = []
        hash.each { |k, v| tmp << URI.encode(k.to_s) + '=' + URI.encode(v.to_s) }
        tmp.join('&')      
      end
    end

    class Bing < Base
      @@max_result_per_page = 50

      def initialize(account_key)
        @account_key = account_key
        @base_url = 'https://api.datamarket.azure.com/Data.ashx/Bing/SearchWeb/Web'
      end

      def search(keyword, params = {}, footprint = {})
        results = []
        limit = params[:limit] || @@max_result_per_page
        offset = params[:offset] || 0
        url = URI.parse(@base_url)
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        https.start do |https|
          results = request(https, url.path, keyword, limit, offset, footprint)
        end
        results
      end  

      private

      def build_querystring(keyword, limit, offset)
        query = {}
        query['Query'] = "'" + keyword + "'"
        query['$top'] = limit.to_s
        query['$skip'] = offset.to_s
        query['$format'] = 'JSON'
        hash_to_querystring(query)        
      end

      def request(http, path, keyword, limit, offset, footprint)
        results = []
        # Bingが勝手にoffsetを修正してわけがわからないことになるので、残り件数にかかわらず、常にlimitを上限にしてリクエストする
        req = Net::HTTP::Get.new(path + '?' + build_querystring(keyword, @@max_result_per_page, offset))
        req.basic_auth(@account_key, @account_key)
        res = http.request(req)
        begin
          json = JSON.parse(res.body)
          json['d']['results'].each do |result|            
            # offset修正ですでに取得済みのものを重複して取得した場合は無視
            next if footprint[result['Url']]
            footprint[result['Url']] = true
            limit -= 1
            offset += 1
            results << {
              :title => result['Title'],
              :url => result['Url'],
              :descriptions => result['Description']
            }
            # 要求している分だけ取得できたらおしまいなので、ループを抜けつつ結果を返す
            return results if limit == 0
          end
          # もし次ページの検索結果がある場合は再帰的に取得
          results += request(http, path, keyword, limit, offset, footprint) if !json['d']['__next'].nil?
        rescue
        end
        results
      end
    end
    
    class Yahoo
    end
    
    class Google  
    end
  end
end
