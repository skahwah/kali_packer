#!/bin/bash
# Created by Sanjiv Kawa
# Twitter: @kawabungah
# 1/23/18
# This downloads the current weekly release of Kali light and creates a VM using packer

# remove previous hashes
rm SHA256SUMS*

# download current weeks hashes
echo "[+] (1/6) Downloading Kali Hashes"
wget http://cdimage.kali.org/kali-images/kali-weekly/SHA256SUMS

# set up some variables
HASH=$(grep "kali-linux-light-2018-.*.-amd64.iso" SHA256SUMS | awk -F" " {'print $1'})
CURRENT=$(grep "kali-linux-light-2018-.*.-amd64.iso" SHA256SUMS | awk -F" " {'print $2'} | cut -d "." -f 1)

# download current weeks light ISO image
echo "[+] (2/6) Downloading $CURRENT.iso"
mkdir iso
if [ ! -f ./iso/$CURRENT.iso ]; then
  wget -P ./iso "http://cdimage.kali.org/kali-images/kali-weekly/$CURRENT.iso"
fi

echo "[+] (3/6) Creating SSH keys"
mkdir ssh
if [ ! -f ./ssh/root-ssh-key ]; then
  ssh-keygen -f ./ssh/root-ssh-key -t rsa -N ''
  cat <<EOF > ./scripts/configure-ssh-for-root.sh
  #!/bin/bash
  # if you want to get vagrant to initiate connections as root, or if you want to initiate connections as root

  PUB="$(cat ./ssh/root-ssh-key.pub)"

  mkdir /root/.ssh
  echo \$PUB >> /root/.ssh/authorized_keys

  chmod 700 /root/.ssh
EOF
  chmod +x ./scripts/configure-ssh-for-root.sh
fi

# create packer file
echo "[+] (4/6) Creating packer file ($CURRENT.json)"
cat <<EOF > $CURRENT.json
{
  "builders":
  [
    {
      "type": "vmware-iso",
      "boot_command": [
        "<esc><wait>",
        "install ",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kali-preseed.cfg ",
        "debian-installer=en_US auto locale=en_US kbd-chooser/method=us <wait>",
        "netcfg/get_hostname=kali ",
        "netcfg/get_domain=unassigned-domain ",
        "fb=false debconf/frontend=noninteractive ",
        "console-setup/ask_detect=false <wait>",
        "console-keymaps-at/keymap=us ",
        "keyboard-configuration/xkb-keymap=us <wait>",
        "<enter><wait10><wait10><wait10>",
        "<enter><wait>"
      ],
      "vm_name": "$CURRENT",
      "guest_os_type": "debian8-64",
      "boot_wait": "10s",
      "disk_size": 20000,
      "http_directory": "./http",
      "headless": false,
      "iso_url": "./iso/$CURRENT.iso",
      "iso_checksum_type": "sha256",
      "iso_checksum": "$HASH",
      "output_directory": "$CURRENT",
      "ssh_port": 22,
      "ssh_username": "root",
      "ssh_password": "toor",
      "ssh_wait_timeout": "30m",
      "vmx_data":
      {
        "cpuid.coresPerSocket": "1",
        "ethernet0.pciSlotNumber": "32",
        "memsize": "2048",
        "numvcpus": "2"
      },
      "shutdown_timeout": "10m",
      "shutdown_command": "echo 'packer' | sudo -S shutdown -P now"
    }
  ],
  "provisioners":
  [
    {
      "type": "shell",
      "scripts":
      [
        "scripts/configure-apt.sh",
        "scripts/vmware-tools.sh",
        "scripts/install-chef.sh",
        "scripts/configure-ssh.sh",
        "scripts/configure-vagrant.sh",
        "scripts/configure-ssh-for-root.sh"
      ]
    }
  ],
  "post-processors":
  [
    {
      "output": "$CURRENT.box",
      "type": "vagrant"
    }
  ]
}
EOF

# remove previous hashes
rm SHA256SUMS

# build the VM and execute any post-processors defined
echo "[+] (5/6) Packing Kali"
./packer build $CURRENT.json

# adding the box into vagrant
read -r -p "(6/6) Do you want to create a vagrant box? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        vagrant box add $CURRENT.box --name $CURRENT
        mkdir vagrant-boxes
        mv $CURRENT.box ./vagrant-boxes
        ;;
    *)
        echo "[-] Skipping vagrant box creation"
        ;;
esac
