#!/bin/sh
# start_pool.sh - GOSTcoin: replace YOUR_GST_ADDRESS, the pool host and port, then: ./start_pool.sh
ADDRESS=YOUR_GST_ADDRESS
WORKER=rig1
POOL=pool.example.com:4033
cd "$(dirname "$0")"
[ "$ADDRESS" = "YOUR_GST_ADDRESS" ] && { echo "Edit start_pool.sh first: put your GOSTcoin address in ADDRESS."; exit 1; }
while true; do
  ./gostminer --pool "$POOL" --user "$ADDRESS.$WORKER" --pass x --log gostminer.log
  echo "Miner stopped (exit code $?), restart in 5 s (Ctrl+C to quit)"; sleep 5
done
