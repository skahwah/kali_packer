#!/bin/bash

# incase you want to get vagrant to initiate connections as root, or if you want to initiate connections as root

echo "ssh-rsa AAAAB .. your root pub key ..." >> /root/.ssh/authorized_keys

chmod 700 /root/.ssh
