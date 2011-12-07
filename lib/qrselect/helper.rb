require 'uri'

module QRSelect
  class Helper
    def self.hash_to_query_string(hash)
      tmp = []
      hash.each { |k, v| tmp << URI.encode(k.to_s) + '=' + URI.encode(v.to_s) }
      tmp.join('&')      
    end
  end
end
