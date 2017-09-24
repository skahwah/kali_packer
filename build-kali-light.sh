#!/bin/bash
# Created by Sanjiv Kawa
# Twitter: @hackerjiv
# 9/21/17
# This downloads the current light weekly release of Kali and creates a VM using packer

# remove previous hashes
rm SHA256SUMS*

# download current weeks hashes
echo "[+] (1/4) Downloading Kali Hashes"
wget http://cdimage.kali.org/kali-images/kali-weekly/SHA256SUMS

# set up some variables
HASH=$(grep "kali-linux-light-2017-.*.-amd64.iso" SHA256SUMS | awk -F" " {'print $1'})
CURRENT=$(grep "kali-linux-light-2017-.*.-amd64.iso" SHA256SUMS | awk -F" " {'print $2'} | cut -d "." -f 1)

# download current weeks full ISO image
echo "[+] (2/4) Downloading $CURRENT.iso"
mkdir iso
wget -P ./iso "http://cdimage.kali.org/kali-images/kali-weekly/$CURRENT.iso"

# update kali-light-2017-2-x64.json with current weeks image name and hash
sed -i .bak "s/kali-linux-2017-.*.-amd64/$CURRENT/g" kali-light-2017-2-x64.json
sed -i .bak "s/\"iso_checksum\": \".*.\"/\"iso_checksum\": \"$HASH\"/g" kali-light-2017-2-x64.json

# create a copy of the packer configuration file and remove previous hashes
cp kali-light-2017-2-x64.json kali-light-2017-2-x64.json.bak
rm SHA256SUMS

# build the VM and execute any post-processors defined
echo "[+] (3/4) Packing Kali"
./packer build kali-light-2017-2-x64.json

# adding the box into vagrant
echo "[+] (4/4) Adding box into Vagrant"
vagrant box add $CURRENT.box --name $CURRENT
