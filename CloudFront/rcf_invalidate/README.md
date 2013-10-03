RHEMS CloudFront Invalidation Too
==========================================
このスクリプトはCloud FrontのInvalidation処理をCLIで行うために開発されました。

S3アクセスキーとアクセスシークレットの設定
==========================================
該当スクリプトはAWSへの接続情報が必要です
実行者の環境変数に以下アクセスキー、アクセスシークレットを設定してください
他者からの読み取りに注意してください。

    export AWS_ACCESS_KEY_ID="(アクセスキー)" 
    export AWS_SECRET_ACCESS_KEY="(アクセスシークレット)" 
    
一時利用の場合、コマンドラインオプションによりこの情報を上書きすることも可能です。

コマンドライン
==========================================

    # rcf_invalidate (オプション)

オプションが無指定の場合、Invalidation可能なディストリビューションの一覧が表示されます

  -a / --access_key
    AWSアクセスキーを指定します。環境変数が設定されている場合、設定を上書きます。
    
  -s / --secret_key
    AWSシークレットキーを指定します。環境変数が設定されている場合、設定を上書きます。

  -d / --dist
    ディストリビューションIDを指定します
    合わせて-rまたは-fの指定が無い場合、現在進行中のInvalidationプロセスを表示します

  -r / --request
    無効化パスを指定して下さい. シェル展開を防ぐためクォートする必要があります

  -f / --request_file
    無効化パスを列挙したファイルを指定して下さい.各パスは改行で区切られている必要があります

  -h / --help
  使い方を表示します

使用例
==========================================

ディストリビューションID一覧を表示する

    $ rcf_invalidate 
    Download Distributions
    ID               Status       Domain Name                            Origin
    --------------------------------------------------------------------------------
    E3RAK4SSNINKCB   Deployed    *********************          <CustomOrigin: *********************>
                              CNAME => *********************
                              CNAME => *********************
    E1G2AZJQ3XPJM4   Deployed     d1r8b6ylicce0s.cloudfront.net          <S3Origin: *********************>
    E3JB12W5SDPNJX   Deployed     d1l47pkibllyda.cloudfront.net          <S3Origin: *********************>
    E18LDW2SZIHD24   Deployed     dkgrg3g61rx40.cloudfront.net           <S3Origin: *********************>
    E1W0RHHPODE6LI   Deployed     d17a7f1aaxoksx.cloudfront.net          <CustomOrigin: origin1.rhems-japan.co.jp>
                              CNAME => cdn1.rhems-japan.co.jp
    E1ELC51RO37SYK   Deployed     d4jt2cz00bfih.cloudfront.net           <CustomOrigin: wowza01.rhems-japan.co.jp>
                              CNAME => hls1.rhems-japan.co.jp
    E33E2FC78ZR14E   Deployed     dxx38m0oqvgzw.cloudfront.net           <S3Origin: rcs-20-20-1-2.s3.amazonaws.com>
                                CNAME => stream1.rhems-japan.co.jp
                                
Invalidateするパスを指定する

    $ rcf_invalidate -d E33EBFC78ZR14E -r '*'
    Request ID: I3OK5PWU3XD74Y
    
Invalidateするパスを列挙したファイルを指定する

    $ rcf_invalidate -d E33EBFC78ZR14E -f test_inv 
    Request ID: I2A2X80XB6CQCI
    
現在進行中のInvalidationプロセスを表示する

    $ rcf_invalidate -d E33EBFC78ZR14E
    ID               Status      
    --------------------------------------------------------------------------------
    I2A2X80XB6CQCI   InProgress  
                   /korekore/bgfio.sh
                   /abeshi/*.pdf
                   /hoge/hoge.jpg
    I3OK5PWU3XD74Y   InProgress  
                 /*
