BEGIN {
        FS="\t";
        OFS="\t";
        instance_key = 0;
        first_ip = "true";
}
{
        if ($1=="INSTANCE") {
                instance_key++;
                first_ip = "true";
                instance[instance_key] = $2;
                if ($19 == "(nil)") {
                        eip[instance_key] = $17;
                        ipaddr_f[instance_key] = $18;
                }
        }
        if ($1=="NICASSOCIATION") {
                eip[instance_key] = $2;
        }
	if ($1=="PRIVATEIPADDRESS") {
                if (first_ip == "true") {
                        ipaddr_f[instance_key] = $2;
                        first_ip = "false";
                } else {
                        ipaddr_s[instance_key] = $2;
                        first_ip = "true";
                }
        }
        if ($1=="TAG") {
                if ($4 == "hostname") {
                        hostname[instance_key] = $5;
                }
        }
	# if ($1=="RESERVATION") {
        #       instance_key++;
        # }
}
END {
        for(key in instance) {
               	print instance[key], (eip[key]) ? eip[key]:"--.--.--.--", (ipaddr_f[key]) ? ipaddr_f[key]:"--.--.--.--", (ipaddr_s[key]) ? ipaddr_s[key]:"--.--.--.--", (hostname[key]) ? hostname[key]:"(no hostname)";
        }
}
