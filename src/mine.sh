#!/bin/bash

if [[ -z "$CPASSWORD" ]]; then
  echo "Starting miner with algorithm '$CALGO'"
  ./cpuminer -a $CALGO -o $CURI -u $CUSERNAME
  # ./cpuminer -a $CALGO -o $CURI -u $CUSERNAME --debug
else
  echo "Starting miner with algorithm '$CALGO' and using password"
  ./cpuminer -a $CALGO -o $CURI -u $CUSERNAME -p $CPASSWORD
  # ./cpuminer -a $CALGO -o $CURI -u $CUSERNAME -p $CPASSWORD --debug
fi
