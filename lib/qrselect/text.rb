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
      @body = @doc.inner_text
      @meta = meta.merge(:title => (@doc.title || '').strip)
      @score = {}
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
      return @score[text.url] if @score.key?(text.url)
      score = 0
      ## textに対するスコアを算出（textが英語の場合しか機能しない…）
      Dictionary.open do |dic|
        words_without_stop_words = text.word_freq.keys - STOP_WORDS
        total = words_without_stop_words.inject(0) do |score, en_word|
          ## 訳語の文中における出現頻度の総和を計算
          freq_of_ja_words = dic.en_to_ja(en_word).inject(0) do |sum, ja_word|
            sum + @body.scan(ja_word).length
          end
          ## 言語の出現頻度と比較して最小値を頻度とする（理由が不明…）
          score + [freq_of_ja_words, text.word_freq[en_word]].min
        end
        score = total / words_without_stop_words.length.to_f        
        @score[text.url] = score
      end
      score
    end

    def domain
      URI.parse(@url).host
    end

    def to_hash
      @meta.merge({ :url => url })
    end

    def word_freq
      unless @word_freq
        @word_freq = {}
        split(/[\s\n]+/).each do |word|
          word.downcase!
          word.delete!(":,.;!?`'\"")
          next if word.empty?
          @word_freq[word] ||= 0
          @word_freq[word] += 1
        end
      end
      @word_freq
    end

    STOP_WORDS = %w(the a an in on at of many much be is are was were been do does did name and to so you most more have has had with but about some its i his her one two three four five six seven eight nine ten lot very go often yet before after now up down it this that these those like also too any only what who where when all every well man woman people make human out though few last almost year first second third he she they or own we us our him say how off back get see know come again men then there here day month if years while rather way still next away just better best other will since over said enough think might should may piece group me which little same thing things such another)
  end
end
