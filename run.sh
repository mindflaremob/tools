#!/bin/bash
# SETUP and RUN
if [ -z "$KEY" ]; then
	exit 1
fi
if [ -z "$RUN" ]; then
	exit 1
fi
if [ ! -e $RUN ]; then
	exit 1
fi
#### SETUP ####
pushd $(dirname $0) &> /dev/null
gunzip age.gz
chmod +x age
echo "$KEY" > key.txt
# decrypt files
./age -i key.txt -d files.age | tar zxf -
mv age bin/
if [ "$USE_PUPPETEER" == "1" ]; then
	#sudo apt-get update
	#sudo apt-get install -y xvfb xauth
	(cd scripts; npm i puppeteer)
fi
export TOOLS_DIR=$(pwd)
export PATH=$PATH:$(pwd)/bin:$(pwd)/scripts
echo "SETUP OK"
#### SECRET SETUP ####
if [ -x scripts/secret-setup.sh ]; then
	bash scripts/secret-setup.sh
fi
#### RUN ####
popd &> /dev/null
exec $RUN
