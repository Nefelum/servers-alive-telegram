API_KEY=$1
CHAT_ID=$2
PATH_TO_IPS=$3

function Ping {
    SERVERIP=$1
    ping -c 3 $SERVERIP > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
        text=$(echo "$output" | sed -r 's/[+]+/%2B/g')
        text="Server $SERVERIP is down"
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d "chat_id=$CHAT_ID" -d text="$text"
    else
        echo "\nServer $SERVERIP is OK!"
    fi
}

function InfiniteLoop {
    input_file=$1
    while :
    do
        while IFS= read -r line
        do
            Ping $line
        done < "$input_file"
    done
}

InfiniteLoop "$PATH_TO_IPS"