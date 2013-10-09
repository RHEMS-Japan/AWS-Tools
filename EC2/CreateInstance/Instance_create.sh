#!/bin/bash
## made by rayman@rhems-japan.co.jp
## ./Instance_create.sh -n <InstanceName> (-G)

############# ENV
export EC2_HOME=/usr/local/ec2-api-tools
export JAVA_HOME=/usr/lib/jvm/jre

## read conf
. ./InstanceCreate.conf

export AWS_ACCESS_KEY=${AWS_ACCESS_KEY}
export AWS_SECRET_KEY=${AWS_SECRET_KEY}

_DATE=`env TZ=JST-9 date +%Y%m%d%H%M%S`

## FontColor (y|g|b|r)
ColorT() {
        _color=$1
        _text=$2

        case "${_color}" in
        "y")
                _color=33;;
        "g")
                _color=32;;
        "b")
                _color=34;;
        "r")
                _color=31;;
        *)
                _color=37
        esac
        echo -e "\033[0;${_color}m${_text}\033[0;39m"

}

Usage() {
	echo "./Instance_create.sh -n <InstanceName> (-G)"
}

CreateInstance() {
	_ETHsub=$1


	echo "======== Create EC2 Instance ========"
	EC2_RUN_RESULT=$(ec2-run-instances --instance-type ${_INS_TYPE} \
        	                           --region ${_REGION} \
                	                   --key ${_KEY} \
                        	           --instance-initiated-shutdown-behavior stop \
					   -s ${_ETHsub} \
					   -g ${_sg} \
                                	   -f ${_autorunsh} ${_AmazonLinuxAMI})
	## check error
	echo -n "Create EC2 Instance : "
	if [ "$?" = "1" ] 
	then
		(ColorT r "ERROR : run-instances") && exit 1
	else
		ColorT g "[ OK ]" 
	fi

	INSTANCE_NAME=$(echo ${EC2_RUN_RESULT} | sed 's/RESERVATION.*INSTANCE //' | sed 's/ .*//')
	_ETH0=$(echo ${EC2_RUN_RESULT} | sed 's/RESERVATION.*NIC //' | sed 's/ .*//')

}

RunningInstance() {
	echo "======== Running Instance ========"
	# Check Instance Running

	for x in `seq 1 100`
	do
		ec2-describe-instances --region ${_REGION} $INSTANCE_NAME | grep -q "running"  >/dev/null 2>&1
		if [ "$?" = "0" ]
		then
			echo -n "Running Instance : "
			ColorT g "[ OK ]"
			break
		else
			[ "$x" = "100" ] && (ColorT r "time out") && exit 1
 			sleep 1
		fi
	done 
}

CreateTags() {
	echo "======== Create Tags ========"
	### CreateTag
	ec2-create-tags ${_ETH0} ${INSTANCE_NAME} --region ${_REGION} --tag "Name=${_AWSNAME}" --tag "hostname=${_Host}" >/dev/null 2>&1
	[ "$?" = "0" ] && ( echo -n "Create Tag : " && ColorT g "[ OK ]" ) || ColorT r "CreateTag NG"
	## CreateVolTags
        for x in `ec2-describe-instances --region ${_REGION} --filter "tag:Name=${_AWSNAME}" | grep BLOCKDEVICE | awk '{print $3}'`
        do
                ec2-create-tags $x --region ${_REGION} --tag "Name=${_AWSNAME}" >/dev/null 2>&1
        done
	[ "$?" = "0" ] && ( echo -n "CreateVol Tag : " && ColorT g "[ OK ]" ) || ColorT r "CreateVolTag NG"
	
}

Addeth1() {
	echo "======== Add eth1 ========"
	ENI_RUN_RESULT=$(ec2-create-network-interface --region ${_REGION} -d ${_AWSNAME} -g ${_sg} ${_eth1sub})
	END_ID=$(echo ${ENI_RUN_RESULT} | awk '{print $2}')
	ec2-create-tags --region ${_REGION} ${END_ID} --tag "Name=${_AWSNAME}" >/dev/null 2>&1
	ec2-attach-network-interface  --region ${_REGION} ${END_ID} -i ${INSTANCE_NAME} -d 1 >/dev/null 2>&1
	[ "$?" = "0" ] && ( echo -n "Add eth1 : " && ColorT g "[ OK ]" ) || ColorT r "Add eth1 NG"
}
AddEIP() {
	echo "======== Add EIP ========"
	EIP_RUN_RESULT=$(ec2-allocate-address --region ${_REGION} -d vpc)
	EIP_ID=$(echo ${EIP_RUN_RESULT} | awk '{print $4}')
	ec2-associate-address --region ${_REGION} -a ${EIP_ID} -n ${_ETH0} >/dev/null 2>&1
	[ "$?" = "0" ] && ( echo -n "Add EIP : " && ColorT g "[ OK ]" ) || ColorT r "Add EIP NG"
}

GetInstanceInfo() {
	echo "++++++++++++++++ VPC Instance INFO ++++++++++++++++"
        ec2-describe-instances --region ${_REGION} --show-empty-fields | awk -f ${tools_dir}/instance_org.awk | grep ${INSTANCE_NAME}
}

SetupHostname() {
	echo "======== SetupHostname ========"
        ec2-reboot-instances --region ${_REGION} ${INSTANCE_NAME}
	[ "$?" = "0" ] && ( echo -n "SetupHostname : " && ColorT g "[ OK ]" ) || ColorT r "SetupHostname NG"
}

################## MAIN
while getopts t:n:G OPT
do
  case $OPT in
    "G" )
        FLG_G="TRUE" ;;
    "n" )
        FLG_n="TRUE"; _Name="$OPTARG" ;;
    "t" )
	FLG_t="TRUE"; _INS_TYPE="$OPTARG";;
      * ) 
	Usage ;exit 1 ;;
  esac
done
if [ ! -n "${_Name}" ]; then
        Usage; exit 1
fi

### MakeHostname
_AWSNAME=${_Host_prefix}_${_Name}
_Host=${_AWSNAME}.${_Host_domain}

## create_autorunsh
cat << EOF > ${_autorunsh}
#cloud-config
repo_upgrade: all
runcmd:
- [cp, /usr/share/zoneinfo/Asia/Tokyo, /etc/localtime]
- [sed, -i, 's/\(HOSTNAME=\).*/\1${_Host}/', /etc/sysconfig/network ]
- [sed, -i, 's/127.0.0.1.*/127.0.0.1 localhost ${_Host}/', /etc/hosts ]
EOF


if [ "${FLG_G}" = "TRUE" ]; then
## add to create_autorunsh
cat << EOF >> ${_autorunsh}
- [cp, /etc/sysconfig/network-scripts/ifcfg-eth0, /etc/sysconfig/network-scripts/ifcfg-eth1 ]
- [sed, -i, 's/eth0/eth1/', /etc/sysconfig/network-scripts/ifcfg-eth1 ]
- echo 'DEFROUTE=no' >> /etc/sysconfig/network-scripts/ifcfg-eth1
- echo 'EC2SYNC=yes' >> /etc/sysconfig/network-scripts/ifcfg-eth1
EOF
	CreateInstance ${_eth0sub}
	RunningInstance
	Addeth1
	AddEIP
else
	CreateInstance ${_eth1sub}
	RunningInstance
fi
CreateTags
GetInstanceInfo
