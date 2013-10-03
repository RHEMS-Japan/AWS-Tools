RHEMS S3 PUT
================================
このスクリプトはboto utilitiesのs3_putを、マルチパートアップロードに対応させたものです。

S3アクセスキーとアクセスシークレットの設定
================================
該当スクリプトはAWSへの接続情報が必要です
実行者の環境変数に以下アクセスキー、アクセスシークレットを設定してください
他者からの読み取りに注意してください。

export AWS_ACCESS_KEY_ID="(アクセスキー)" 
export AWS_SECRET_ACCESS_KEY="(アクセスシークレット)" 

一時利用の場合、コマンドラインオプションによりこの情報を上書きすることも可能です。

コマンドライン
================================

# rs3_put (オプション) -b (バケット名) (アップロードファイル or ディレクトリ)

-a / --access_key
AWSアクセスキーを指定します。環境変数が設定されている場合、設定を上書きます。
-s / --secret_key
AWSシークレットキーを指定します。環境変数が設定されている場合、設定を上書きます。
-b / --bucket
転送先とするS3バケット名を指定します。
-c / --callback
転送中指定間隔でコールバック表示を行います。
-d / --debug
デバッグレベルでのメッセージ表示を行います。
0 (default) / 1 (normal) / 2(リクエスト・レスポンスを含めたデバッグ表示)
-i / --ignore
コピー除外するディレクトリをカンマ区切りで指定します
-n / --no_op
S3転送を行いません。情報のみ表示します
-p / --prefix
プレフィックスとしてS3キー名から除外します。
/var/log/hogehoge.log に対して -p /var/log/ を指定した場合 (バケット名)/hogehoge.logとして展開されます。
なお、プレフィックスはディレクトリ区切り記号で終わる必要があります。
-q / --quiet
標準出力は抑制され、静かにプログラムは実行されます。
-g / --grant
カノニカル名を使ってACLポリシーを指定します。
private, public-read, public-read-write, authenticated-read 等が指定できます。
-w / --no_overwrite
上書きを禁止します。
転送が中断された場合等、指定する必要があります。
-r / --reduced
RRS (低可用性ストレージ) を使用します。

注意
================================
ACLポリシーが無指定の場合、オーナーフルコントロールとなります。

ディレクトリをアップロードする際、S3側のキー名は以下のようになります
例1) rs3_put -b rhems_log /var/log/apache
/rhems_log/var/log/apache/hogehoge1.log
/rhems_log/var/log/apache/hogehoge2.log
/rhems_log/var/log/apache/hogehoge3.log
/rhems_log/var/log/apache/hogehoge4.log
例2) cd /var/log ; rs3_put -b rhems_log apache
/rhems_log/var/log/apache/hogehoge1.log
/rhems_log/var/log/apache/hogehoge2.log
/rhems_log/var/log/apache/hogehoge3.log
/rhems_log/var/log/apache/hogehoge4.log
例1と例2は同じキー名となります。これは送信元がディレクトリの場合は現在位置とは関係なくバケット名＋フルパス名がキー名として適用されるためです。

例3) rs3_put -p /var/log/ -b rhems_log /var/log/apache
/rhems_log/apache/hogehoge1.log
/rhems_log/apache/hogehoge2.log
/rhems_log/apache/hogehoge3.log
/rhems_log/apache/hogehoge4.log
-p オプションにより、ディレクトリプレフィックスを除外してキーを設定できます。
