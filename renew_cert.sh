#!/bin/bash

domains=("example.com")
cert_root=/usr/syno/etc/certificate/_archive
gen_root=/volume1/docker/acme
isChange=false
#docker exec acme acme.sh --issue --dns dns_cf -d ${domain} -d *.${domain}
#openssl x509 -noout -subject -in cert.pem | awk '{print $NF}'

function findPath() {
	# $1 is domain
	cert_list=(`find ${cert_root} -name cert.pem`)
	for cert_name in ${cert_list[@]}; do
		cert_tmp=`openssl x509 -noout -subject -in ${cert_name} | awk '{print $NF}'`
		if [ "${1}" == "${cert_tmp}" ]; then
			dirname ${cert_name}
			break
		fi
	done
}

function replaceCert() {
	# $1 is domain
	# $2 is cert_path
	cert_path=$2
	gen_path=${gen_root}/$1
	if cmp -s ${cert_path}/cert.pem ${gen_path}/${domain}.cer; then
		:
	else
		rsync -avh "${gen_path}/${domain}.cer" "${cert_path}/cert.pem"
		rsync -avh "${gen_path}/${domain}.key" "${cert_path}/privkey.pem"
		rsync -avh "${gen_path}/fullchain.cer" "${cert_path}/fullchain.pem"
		rsync -avh "${gen_path}/ca.cer" "${cert_path}/chain.pem"
		isChange=true
	fi
}

for domain in ${domains[@]}; do
	cert_path=$(findPath "${domain}")

	replaceCert "${domain}" "${cert_path}"
done

if $isChange ; then
	echo "Reload nginx"
	synow3tool --gen-all && systemctl reload nginx
fi

