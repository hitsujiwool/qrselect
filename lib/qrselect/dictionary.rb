# -*- coding: utf-8 -*-
require 'mysql2'

module QRSelect
  class Dictionary
    def self.open(&block)
      username, host = Config::MYSQL_USER.split('@')      
      @@db = Mysql2::Client.new(:host=> host, :username => username, :password => Concif::MYSQL_PASSWORD, :database => Config::MYSQL_DBNAME)
      begin
        block.call(Dictionary.new)
      rescue
        @@db.close
      end
    end
    
    def en_to_ja(word)
      escaped = @@db.escape(word)
      @@db.query("select jword from eijiro where eword = '#{escaped}'").map { |row|
        row['jword'].split("\t").map { |word|
          word
            .delete('〜')
            .gsub(/\(.+?\)/, '')
            .gsub(/\[.+?\]/, '')
        }.delete_if { |word|
          word =~ /^[ぁ-ん]+$/
        }
      }.flatten
    end
  end
end
