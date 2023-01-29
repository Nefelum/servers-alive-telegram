API_KEY=$1
CHAT_ID=$2

function Ping {
    SERVERIP=$1
    ping -c 3 $SERVERIP > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
        text=$(echo "$output" | sed -r 's/[+]+/%2B/g')
        text="Server $SERVERIP is down"
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d "chat_id=$CHAT_ID" -d text="$text"
    else
        echo "Server is OK!"
    fi
}

function InfiniteLoop {
    input_file=$1
    while IFS= read -r line
    do
#        echo "$line"
#        line=( $line )
#        ip=${line[0]}
        Ping $line
    done < "$input_file"
}

InfiniteLoop "/home/.../ips"