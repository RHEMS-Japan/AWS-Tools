RHEMS Japan is very particular about ...
================================
RHEMS Japan is very particular about uing Command Line Interface(cli)
The reasons are:
	・improvement of operational efficiency
	・by using cli, history can be checked easily
	・review of work can be done easily

AWS Command Line Interface
================================
AWS can work easily by using  web interface.
But not all features are available, such as auto scale.
Also we think mouse control can make careless mistake.

aws has greate cli tools
http://aws.amazon.com/jp/cli/

to stop these mistake we are making thirdparty tools.

RHEMS Japanのこだわり
================================
RHEMS JapanはとことんCommand Line Interface(cli)にこだわる会社です。
その理由としては
	・作業の効率化
	・作業履歴を確認できる
	・作業計画が立てやすくなる


AWSをコマンドラインから
================================
AWSはweb interfaceを使うことで簡単に作業ができます。
ですがAWSはweb interfaceではできない事も実はあります。(auto scaleなど)
またwebでの操作では間違ってクリックする単純なオペミス、見間違いなどが起こる可能性があります。
それらを排除するためRHEMS Japanではawsをcliから操作できる便利ツールを開発しています。

awsにはすでに素晴らしいcliのツールがあります。
http://aws.amazon.com/jp/cli/

弊社はこれらのツールを使いより簡単に操作、運用できる新たなツールを用意しより作業の効率化を求めています。


AWS VPC インスタンスの作成(AmazonLinux専用)
==============================
このツールを使うことでEBSやENIなどのtagが自動で設定されます。
また、インスタンのNTPを日本に設定したりhostnameやhostsの編集なども行われます。

Configfile:
	$ cat InstanceCreate.conf
	## Tools prefirx
	tools_dir=<dir>
	## AWS KEY/SECRET
	AWS_ACCESS_KEY=<AWS_ACCESS_KEY>
	AWS_SECRET_KEY=<AWS_SECRET_KEY>
	## Tokyo
	_REGION=<aws REGION>
	## AmazonLinuxAMI
	_AmazonLinuxAMI=<ami id>
	## Key
	_KEY=<Key Pair Name:>
	_Host_prefix=<domain prefix>
	_Host_domain=<domain>
	## Security Group (RHEMS Japan)
	_sg=<Security Groups>
	_eth0sub=<Subnet ID>
	_eth1sub=<Subnet ID>
	_autorunsh=<auto run temp file>

How to user:
	$ ./Instance_create.sh -n <Instance Name> -t <Instance Type> <-G>
		-G : attache Global IP(EIP)
	
	$ ./Instance_create.sh -n test -t t1.micro -G

Run example:
	# ./Instance_create.sh -n RHEMS-test -G -t t1.micro
	======== Create EC2 Instance ========
	Create EC2 Instance : [ OK ]
	======== Running Instance ========
	Running Instance : [ OK ]
	======== Add eth1 ========
	Add eth1 : [ OK ]
	======== Add EIP ========
	Add EIP : [ OK ]
	======== Create Tags ========
	Create Tag : [ OK ]
	++++++++++++++++ VPC Instance INFO ++++++++++++++++
	i-ba754dbf      54.238.160.204  10.101.0.116    10.101.1.183    RHEMS_RHEMS-test.aws.rhems-japan.net
