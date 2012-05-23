# -*- coding: utf-8 -*-
module QRSelect
  class Main
    DEFAULTS = {
      :expand => false,
      :domain => nil,
      :limit => 50,
      :recursive => false,
      :engine => Search::Bing
    }
    
    def close
      @closed = true
    end
    
    def fetch (keyword, params = {}, &block)
      raise 'QRSelect::Config is not initialized.' unless Config.initialized?
      params = DEFAULTS.merge(params)
      footprint = Footprint.new
      if params[:expand]
        if params[:expand].is_a?(Array)
          ## 配列ならそれを使う
          keywords = params[:expand].map { |k| "#{keyword} #{k}" }
        else
          ## 単にtrue指定ならデフォルトのキーワードを使う
          keywords = Config::ADDITIONAL_KEYWORDS.map { |k| "#{keyword} #{k}" }
        end
      else
        keywords = [keyword]
      end
      ## 必要ならばドメイン指定用のクエリを追加
      keywords = keywords.map { |k| "#{k} site:#{params[:domain]}" } if params[:domain]      
      ## enumeratorを使って遅延評価
      enum = Enumerator.new do |y|
        keywords.each do |k|
          collection = ResultCollection.new(k, footprint, params[:engine], params[:recursive])
          loop do
            break if @closed
            result = collection.next
            unless result.candidates.empty?
              block.call(result) if block_given?
              y << result
            end
          end
        end
      end
      enum.take(params[:limit])
    end
  end
end
