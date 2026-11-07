#!/bin/sh
# start_bitmark.sh - Bitmark (lyra2v2): replace YOUR_MARKS_ADDRESS, the pool host and port, then: ./start_bitmark.sh
ADDRESS=YOUR_MARKS_ADDRESS
WORKER=rig1
POOL=pool.example.com:4034
cd "$(dirname "$0")"
[ "$ADDRESS" = "YOUR_MARKS_ADDRESS" ] && { echo "Edit start_bitmark.sh first: put your Bitmark address in ADDRESS."; exit 1; }
while true; do
  ./gostminer --algo lyra2v2 --pool "$POOL" --user "$ADDRESS.$WORKER" --pass x --log gostminer_bitmark.log
  echo "Miner stopped (exit code $?), restart in 5 s (Ctrl+C to quit)"; sleep 5
done
