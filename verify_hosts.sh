#!/bin/bash
HOSTS_FILE=$1
if [ ! -f "$HOSTS_FILE" ]; then
    echo "Error: File $HOSTS_FILE does not exist."
    exit 1
fi

verify_IP() {
    local host_name=$1
    local file_ip=$2
    local actual_ip=$(nslookup "$host_name" 2>/dev/null | grep 'Address:' | tail -n 1 | awk '{print $2}')
    if [ "$actual_ip" != "$file_ip" ]; then
        echo "Bogus IP for $host_name in $HOSTS_FILE !"
        return 1
    fi
    return 0
}
while read -r ip name rest; do
    if [[ "$ip" == 127.* || "$ip" == ::* || -z "$ip" ]]; then continue; fi
    verify_IP "$name" "$ip"
done < "$HOSTS_FILE"
