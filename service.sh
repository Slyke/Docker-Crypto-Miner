#!/bin/bash

# Not yet completed
echo "Not yet completed"
exit 0
# docker service scale miner=0 # To Stop
# docker service scale miner=4

# docker service create \
#   --limit-cpu 4 \
#   --name miner wernight/cpuminer-multi cpuminer \
#   -a scrypt \
#   -p passqwerty123 \
#   -o stratum+tcp://scrypt.usa.nicehash.com:3333 \
#   -u btcaddresshere

# docker run --rm --cpus="4" --name miner wernight/cpuminer-multi cpuminer -a scrypt -p passqwerty123 -o stratum+tcp://scrypt.usa.nicehash.com:3333 -u btcaddresshere

# docker service scale miner=0 # To Stop
# docker service scale miner=4
