# -*- coding: utf-8 -*-
require 'spec_helper'

describe QRSelect do
  ## テストのmatcherが書かれていないので、厳密なテストケースではありません。あくまでオプションの参考用
  it '検索がヒットしなくなるか、結果がlimitの値に達するまで探索する（デフォルトは50件）' do
    QRSelect.fetch('コロンビア 麻薬', :limit => 5)
  end

  it 'configのadditional_keywordsで設定したキーワードを付加して検索する（デフォルトはfalse）' do
    QRSelect.fetch('コロンビア 麻薬', :limit => 5, :expand => true)
  end

  it '対訳が見つかったら、翻訳ページのドメインを付加して再度検索し、探索対象URLを増やす（デフォルトはfalse）' do
    QRSelect.fetch('コロンビア 麻薬', :limit => 5, :recursive => true)
  end

  it '指定したドメインのみを探索対象とする（注：原文候補はドメインの制約を受けない）' do
    QRSelect.fetch('コロンビア 麻薬', :limit => 5, :domain => 'ac.jp')
  end

  it '結果を取得するたびにブロックを評価' do
    QRSelect.fetch('コロンビア 麻薬') do |result|
      print <<EOS
========================================
#{result.seed.title} (#{result.seed.url})
#{result.candidates.length}件の対訳候補が見つかりました。
#{result.highest_score_text.title} (#{result.highest_score_text.url}) 
========================================
EOS
    end
  end  
end
