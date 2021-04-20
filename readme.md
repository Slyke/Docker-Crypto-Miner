# Docker bitcoin miner for RPi

## Run:
```
$ export CPUMINER_USERNAME=yourUsername
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
$ export CPUMINER_PASSWORD="a=scrypt,c=dogecoin,n=RPi1"
$ ./start.sh
```

## Stop:
```
$ export CPUMINER_USERNAME=yourUsername
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
$ export CPUMINER_PASSWORD="a=scrypt,c=dogecoin,n=RPi1"
$ ./start.sh stop
```

## Info
Different coins use different ports. Be sure to set your URI correctly. ProHashing sets configuration using the password field. See https://prohashing.com/tools/miner-configurator/ for details.

The `CPUMINER_PASSWORD` environment variable is optional.

This code should work on most debian systems (not just Raspberry Pis).

## Change settings:
```
$ export CPUMINER_USERNAME=yourUsername
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
$ export CPUMINER_PASSWORD="a=scrypt,c=dogecoin,n=RPi1"
$ ./start.sh rebuild
```

More examples:
```
$ export CPUMINER_USERNAME=yourUsername
$ CPUMINER_URI=stratum+tcp://prohashing.com:3336 -p "a=scrypt"
$ ./start.sh

# Doge:
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
$ export CPUMINER_PASSWORD="a=scrypt,c=dogecoin,n=RPi1"

# Scrypt:
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3333"
$ export CPUMINER_PASSWORD="a=scrypt,d=16384,n=RPi1"

# Ethereum:
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3339"
$ export CPUMINER_PASSWORD="a=ethash,c=ethereum,n=RPi1"

# Other:
$ export CPUMINER_URI="stratum+tcp://prohashing.com:3336"
$ export CPUMINER_PASSWORD="a=equihash,n=RPi1"
```