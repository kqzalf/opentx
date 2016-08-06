#!/bin/bash
 
set -e

branch=next
workdir=/home/opentx/nightly22
output=/var/www/html/2.2/nightly

cd ${workdir}

# Copy git sdcard data
rm -Rf ${workdir}/sdcard
cp -r ${workdir}/code/radio/sdcard .

# Get images for Horus
mkdir -p ${workdir}/sdcard/horus/IMAGES
cp /home/opentx/horus-bitmaps/* ${workdir}/sdcard/horus/IMAGES/

# Request sound pack generation
wget -qO- http://winbox.open-tx.org/voice-builds/compile22.php?branch=${branch}

# Get sounds
cd sdcard
wget http://winbox.open-tx.org/voice-builds/english-irish-taranis.zip
wget http://winbox.open-tx.org/voice-builds/english-scottish-taranis.zip
wget http://winbox.open-tx.org/voice-builds/english-american-taranis.zip
wget http://winbox.open-tx.org/voice-builds/english-australian-taranis.zip
wget http://winbox.open-tx.org/voice-builds/english-english-taranis.zip
wget http://winbox.open-tx.org/voice-builds/french-taranis.zip

# Prepare the sdcard zip files for Horus
unzip english-irish-taranis.zip -d  ${workdir}/sdcard/horus
mv ${workdir}/sdcard/horus/SOUNDS/en ${workdir}/sdcard/horus/SOUNDS/en-irish
unzip english-scottish-taranis.zip -d  ${workdir}/sdcard/horus
mv ${workdir}/sdcard/horus/SOUNDS/en ${workdir}/sdcard/horus/SOUNDS/en-scottish
unzip english-australian-taranis.zip -d  ${workdir}/sdcard/horus
mv ${workdir}/sdcard/horus/SOUNDS/en ${workdir}/sdcard/horus/SOUNDS/en-australian
unzip english-american-taranis.zip -d  ${workdir}/sdcard/horus
mv ${workdir}/sdcard/horus/SOUNDS/en ${workdir}/sdcard/horus/SOUNDS/en-american
unzip english-english-taranis -d  ${workdir}/sdcard/horus
unzip french-taranis.zip -d  ${workdir}/sdcard/horus
wget -O ${workdir}/sdcard/horus/SOUNDS/en/english.csv http://winbox.open-tx.org/voice-builds/english-english-taranis.csv
wget -O ${workdir}/sdcard/horus/SOUNDS/fr/french.csv http://winbox.open-tx.org/voice-builds/french-taranis.csv

# Duplicate for Taranis and create sdcards.zip
mkdir ${workdir}/sdcard/taranis/SOUNDS
cp -r ${workdir}/sdcard/horus/SOUNDS ${workdir}/sdcard/taranis/
rm -f ${workdir}/sdcard/*.zip
cd ${workdir}/sdcard/taranis && zip -r ${output}/sdcard/sdcard-taranis.zip *
cd ${workdir}/sdcard/horus && zip -r ${output}/sdcard/sdcard-horus.zip *
rm -Rf ${workdir}/sdcard
