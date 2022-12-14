#!/bin/bash
#useful for waiting for payments or seeing your wallet balance live
ADDRESS2="bc1qu3ds562w2av52rz8xl0pm5jkk66s5ep95e4wwp" #using my own for now you can replace with yours and use ./cb.sh 1 to use it or type actual address
oldbalance=0
n=0

FILE=./tmp
if test -f "$FILE"; then
    date1=$(cat tmp)
    echo "restored timestamp from file, info will be updated next cycle could be 20 min old"
    else
       date1=$(date  +%s%3N)  #$(date -d'+20minutes' +%s%3N)
       echo $date1 > tmp
fi


if [[ $1 != "" ]] ; then ADDRESS=$1 ; fi # use alternate address if specified
if [[ $1 = "1" ]] ; then ADDRESS=$ADDRESS2 ; fi # use alternate address if specified
if [[ $1 = "" ]] ; then echo "insert address" ; fi # use alternate address if specified
while true;do
    n=$(($n+1))
    if [[ $ADDRESS != "" ]] ; then
    echo ": Address : $ADDRESS"
    dateepoc=$(( $(date  +%s%3N) ))
        if [[ $dateepoc > $date1 ]] ; then
            wget -qO- https://blockchain.info/balance?active=$ADDRESS > ./tbalance
            echo "updated info"
            echo $(date -d'+20minutes' +%s%3N) > tmp        
        fi
    fi
    #balance=$(wget -qO- https://blockchain.info/balance?active=$ADDRESS 2>&1 | grep -Po '"total_received":\K[0-9]+' | awk '{s=$1/100000000} END {printf "%0.8f\n", s}')

    transactions=$(cat ./tbalance | grep -Po '"n_tx":\K[0-9]+' | awk '{s=$1/1} END {printf "%0.1f\n", s}')
    balance=$(cat ./tbalance | grep -Po '"total_received":\K[0-9]+' | awk '{s=$1/100000000} END {printf "%0.8f\n", s}')
    
  fbalance=$(cat ./tbalance | grep -Po '"final_balance":\K[0-9]+' | awk '{s=$1/100000000} END {printf "%0.8f\n", s}')
    echo "$n / Tx number : $transactions /   Received : $balance   /    Final Balance : $fbalance"

    if [[ $balance != $oldbalance && $n != "1" ]]; then
        #beep
        echo -en "\007"
        spd-say 'Funds Have Been Deposited'
        echo "balance updated"
    fi
    
    oldbalance=$balance
    
    #sleep 100 #testing offline only
    sleep 3000 #10-15 20 min
done
