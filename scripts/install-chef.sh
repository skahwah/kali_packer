#!/bin/bash
# Created by Sanjiv Kawa
# Twitter: @hackerjiv
# 1/23/18

wget https://packages.chef.io/files/stable/chef/13.4.24/debian/8/chef_13.4.24-1_amd64.deb -O ~/chef.deb
dpkg -i ~/chef.deb
rm  ~/chef.deb
