AWS VPC インスタンスの作成(AmazonLinux専用)
==============================
このツールを使うことでEBSやENIなどのtagが自動で設定されます。
また、インスタンのNTPを日本に設定したりhostnameやhostsの編集なども行われます。


[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/ivwK6NEw9fA/0.jpg)](http://www.youtube.com/watch?v=ivwK6NEw9fA)


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

