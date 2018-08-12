#!/bin/bash

# CHANGE THESE
auth_email=""
auth_key=""

zone_name=""
record_name=""

zone_name2=""
record_name2=""

zone_name3=""
record_name3="ml"

zone_name4=""
record_name4=""


# MAYBE CHANGE THESE
ip=$(curl -s http://ipv4.icanhazip.com)
ip_file="ip.txt"
id_file="cloudflare.ids"
id_file2="cloudflare.ids2"
id_file3="cloudflare.ids3"
id_file4="cloudflare.ids4"
log_file="cloudflare.log"

# LOGGER
log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1" >> $log_file
    fi
}

# SCRIPT START
log "Check Initiated"

if [ -f $ip_file ]; then
    old_ip=$(cat $ip_file)
    if [ $ip == $old_ip ]; then
        echo "IP has not changed."
        exit 0
    fi
fi

if [ -f $id_file ] && [ $(wc -l $id_file | cut -d " " -f 1) == 2 ]; then
    zone_identifier=$(head -1 $id_file)
    record_identifier=$(tail -1 $id_file)
else
    zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
    record_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')
    echo "$zone_identifier" > $id_file
    echo "$record_identifier" >> $id_file
fi

if [ -f $id_file2 ] && [ $(wc -l $id_file2 | cut -d " " -f 1) == 2 ]; then
    zone_identifier2=$(head -1 $id_file2)
    record_identifier2=$(tail -1 $id_file2)
else
    zone_identifier2=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name2" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
    record_identifier2=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier2/dns_records?name=$record_name2" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')
    echo "$zone_identifier2" > $id_file2
    echo "$record_identifier2" >> $id_file2
fi

if [ -f $id_file3 ] && [ $(wc -l $id_file3 | cut -d " " -f 1) == 2 ]; then
    zone_identifier3=$(head -1 $id_file3)
    record_identifier3=$(tail -1 $id_file3)
else
    zone_identifier3=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name3" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
    record_identifier3=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier3/dns_records?name=$record_name3" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')
    echo "$zone_identifier3" > $id_file3
    echo "$record_identifier3" >> $id_file3
fi

if [ -f $id_file4 ] && [ $(wc -l $id_file4 | cut -d " " -f 1) == 2 ]; then
    zone_identifier4=$(head -1 $id_file4)
    record_identifier4=$(tail -1 $id_file4)
else
    zone_identifier4=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name4" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
    record_identifier4=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier4/dns_records?name=$record_name4" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')
    echo "$zone_identifier4" > $id_file4
    echo "$record_identifier4" >> $id_file4
fi

update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"proxied\":true}")
update2=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier2/dns_records/$record_identifier2" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier2\",\"type\":\"A\",\"name\":\"$record_name2\",\"content\":\"$ip\",\"proxied\":true}")
update3=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier3/dns_records/$record_identifier3" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier3\",\"type\":\"A\",\"name\":\"$record_name3\",\"content\":\"$ip\",\"proxied\":true}")
update4=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier4/dns_records/$record_identifier4" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier4\",\"type\":\"A\",\"name\":\"$record_name4\",\"content\":\"$ip\",\"proxied\":true}")



if [[ $update == *"\"success\":false"* ]]; then
    message="API UPDATE FAILED. DUMPING RESULTS:\n$update"
    log "$message"
    echo -e "$message"
    exit 1 
else
    message="IP changed to: $ip on $zone_name"
    echo "$ip" > $ip_file
    log "$message"
    echo "$message"
fi

if [[ $update2 == *"\"success\":false"* ]]; then
    message="API UPDATE FAILED. DUMPING RESULTS:\n$update2"
    log "$message"
    echo -e "$message"
    exit 1 
else
    message="IP changed to: $ip on $zone_name2"
    echo "$ip" > $ip_file
    log "$message"
    echo "$message"
fi

if [[ $update3 == *"\"success\":false"* ]]; then
    message="API UPDATE FAILED. DUMPING RESULTS:\n$update3"
    log "$message"
    echo -e "$message"
    exit 1 
else
    message="IP changed to: $ip on $zone_name3"
    echo "$ip" > $ip_file
    log "$message"
    echo "$message"
fi

if [[ $update4 == *"\"success\":false"* ]]; then
    message="API UPDATE FAILED. DUMPING RESULTS:\n$update4"
    log "$message"
    echo -e "$message"
    exit 1 
else
    message="IP changed to: $ip on $zone_name4"
    echo "$ip" > $ip_file
    log "$message"
    echo "$message"
fi