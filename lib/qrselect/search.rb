require 'uri'
require 'nokogiri'
require 'open-uri'
require 'delegate'

module QRSelect
  module Search
    class Base
      def to_enum(keyword, limit = nil)
        Enumerator.new do |y|
          offset = 0
          loop do
            results = search(keyword, :offset => offset)
            break if results.empty? || (limit && limit <= offset)
            results.each do |result|
              y << result
              offset += 1
            end
          end
        end      
      end
    end

    class Bing < Base
      @@max_result_per_page = 50

      def initialize
        @base_url = 'http://api.bing.net/xml.aspx'
        @query = {
          'AppId' => Config::BING_APP_ID,
          'Version' => '2.2',
          'Market' => 'ja-JP',
          'Sources' => 'Web',
        }
      end

      def generate_url(keyword, limit, offset)
        query = @query.clone
        query['Query'] = keyword
        query['Web.Count'] = limit.to_s
        query['Web.Offset'] = offset.to_s
        @base_url + '?' + Helper.hash_to_query_string(query)
      end

      def search(keyword, params = {})
        limit = params[:limit] || @@max_result_per_page
        offset = params[:offset] || 0
        doc = Nokogiri::XML(open(generate_url(keyword, [limit, @@max_result_per_page].min, offset)))
        ns = {
          'default' => 'http://schemas.microsoft.com/LiveSearch/2008/04/XML/element',
          'web' => 'http://schemas.microsoft.com/LiveSearch/2008/04/XML/web'
        }
        results = []
        unless doc.at('/default:SearchResponse/default:Errors', ns)
          total = doc.at('//web:Total', ns).inner_text.to_i
          if offset < total
            real_offset = doc.at('//web:Offset', ns).inner_text.to_i
            doc.xpath('//web:WebResult', ns).each do |node|
              results << {
                :title => node.xpath('web:Title', ns).inner_text,
                :url => node.xpath('web:Url', ns).inner_text,
                :description => node.xpath('web:Description', ns).inner_text
              }
            end
            if limit - @@max_result_per_page > 0 && results.length + real_offset < total
              results = results.concat(search(keyword, :limit => limit - @@max_result_per_page, :offset => @@max_result_per_page))
            end
          end
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
