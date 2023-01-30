API_KEY=$1
CHAT_ID=$2
PATH_TO_IPS=$3
BAD_IPS_ARRAY=()

function Ping {
    SERVERIP=$1
    sleep 10
    ping -c 3 "$SERVERIP" > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
        BAD_IPS_ARRAY+=("$SERVERIP")
        text="Server $SERVERIP is down"
        curl -s -X POST https://api.telegram.org/bot$API_KEY/sendMessage -d "chat_id=$CHAT_ID" -d text="$text"
    else
        echo -e "\nServer $SERVERIP is OK!"
    fi
}

function InfiniteLoop {
    input_file=$1
    while :
    do
        while IFS= read -r line
        do
            SERVERIP=$line
            IsDown=$(BadIpExists "$SERVERIP")
            if [ "$IsDown" = "Server $SERVERIP was down" ]; then
                sleep 5
                echo "Server $SERVERIP was down"
            else
                Ping "$SERVERIP"
            fi
        done < "$input_file"
    done
}


function BadIpExists {
    check_ip=$1
    for ip in "${BAD_IPS_ARRAY[@]}"
    do
        if [ "$check_ip" = "$ip" ]; then
            echo "Server $check_ip was down"
            return 1
        fi
    done
    echo "Server $check_ip is up!"
}


#function CheckIp {
#    check_ip=$1
#    for ip in "${BAD_IPS_ARRAY[@]}"
#    do
#        if [ "$check_ip" = "$ip" ]; then
#            echo "Server $check_ip was already down"
#        fi
#    done
#}

InfiniteLoop "$PATH_TO_IPS"
