# -*- coding: utf-8 -*-
require 'delegate'
require 'nokogiri'
require 'open-uri'

module QRSelect
  class Text < Delegator
    attr_reader :url

    def initialize(url, meta = {})
      @doc = Nokogiri.HTML(Kernel.open(url))
      @url = url
      @body = @doc.inner_text.freeze
      @meta = meta
    end
    
    def __getobj__
      @body
    end
    
    def method_missing(method, *args, &block)
      if @meta.key?(method)
        @meta[method]
      else
        super(method, *args, &block)
      end
    end
    
    def inspect
      @meta.map { |k, v| "#{k}: #{v}" }.join("\n") + "\n" + @body
    end

    def english?
      ## theの出現頻度が上位10位以内で、かつ5回以上の出現で英語テキストとみなす
      rank('the') <= 10 && freq('the') >= 5
    end

    def rank(word)
      n = freq(word)
      word_freq.values.select { |i| n < i }.length + 1
    end

    def freq(word)
      word_freq[word] ? word_freq[word] : 0
    end

    def extract_links
      @doc.search('a').inject([]) do |result, elem|
        if Config::ADDITIONAL_KEYWORDS.any? { |keyword| elem.inner_text.include?(keyword) }
          result << elem[:href]
        end
        result
      end
    end
    
    def score_to(text)
      1
    end

    def domain
      URI.parse(@url).host
    end

    def to_hash
      @meta.merge({ :url => url })
    end

    private

    def word_freq
      unless @word_freq
        @word_freq = {}
        split(/[\s\n]+/).each do |word|
          word.downcase!
          word.delete!(':,.;')
          @word_freq[word] ||= 0
          @word_freq[word] += 1
        end
      end
      @word_freq
    end
  end
end
