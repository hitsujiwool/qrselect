# QRselect
指定したキーワードに関連する対訳文書をウェブ上から収集するシステムです。

## インストール
    $ git clone https://github.com/hitsujiwool/qrselect.git qrselect
    $ cd qrselect
	$ rake build
	$ rake install
## 使い方

### 設定ファイルのロード

ますは、動作に必要な各種情報（MySQLのユーザー情報や検索エンジンのAPIキー）を記載した読み込む必要があります。設定ファイルの雛形として、リボジトリ内のakin.confを使用して下さい。

	QRselect.config(/path/to/config)
	
akin.confはyamlで記述されているので、同等の内容をハッシュ形式で渡すこともできます。

	QRselect.config(:mysql_user => 'foo', :mysql_password => 'bar')

### QRselect.fetch
	
`QRselect.fetch`を実行すると、収集結果が配列として返ります。配列の要素はQRselect::Resultオブジェクトで、日本語テキストの情報や、対訳候補として収集された英語テキストの情報、各テキストのスコア等が格納されています。
	
	results = QRselect.fetch('コロンビア 麻薬')
	results.each do |result|
      result.seed.title ## 日本語テキストのタイトル
      result.seed.url ## 日本語テキストのURL
      result.candidates.length ## 対訳候補の数
	  result.highest_score_text.title} ## もっともスコアの高かったテキストのタイトル
    end
	
ブロックを渡して、結果を1件収集するごとに処理を実行できます。	

	results = QRselect.fetch('コロンビア 麻薬') do |result|
      ## do something
    end
	
## オプション

`QRselect.fetch`にはいくつかのオプションを渡すことができます。

    QRselect.fetch('コロンビア 麻薬', :limit => 10,
		                              :expand => true,
									  :domain => 'ac.jp',
									  :recursive => true)

* :limitは、出力される結果の件数を指定します（デフォルトは50）。
* :expandがtrueの場合、akin.confに書かれた追加キーワードをクエリの末尾に付加して検索します。
* :domainは、検索する日本語テキストのドメインを絞りこみます。
* :recursiveがtrueの場合、原文の候補が見つかったときに、もとになった日本語ページと同一ドメインのページについても対訳を収集します。


### コマンドラインからの利用
コマンドラインから使用する場合は、カレントディレクトリ内のakin.confが自動でロードされます。詳細は`qrselect -h`をご覧下さい。
	
