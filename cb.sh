#!/bin/bash
#useful for waiting for payments or seeing your wallet balance live
ADDRESS=bc1qu3ds562w2av52rz8xl0pm5jkk66s5ep95e4wwp

oldbalance=0
if [[ $1 != "" ]] ; then ADDRESS=$1 ; fi # use alternate address if specified
while true;do
echo $ADDRESS;
balance=$(wget -qO- https://blockchain.info/balance?active=$ADDRESS 2>&1 | grep -Po '"total_received":\K[0-9]+' | awk '{s=$1/100000000} END {printf "%0.8f\n", s}')
echo "Balance : $balance"
if [[ balance != oldbalance ]]; then
    #beep
    echo -en "\007".
    spd-say 'Funds Have Been Deposited'
    echo "balance updated"
fi
oldbalance=balance
sleep 1500 #10-15 min
done
#0.05185304

