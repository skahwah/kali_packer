# kali_packer

## Pre-requisites
- VMWare Fusion or VMWare Workstation
- Vagrant

The purpose of this is to automate the creation of a new Kali VM using the most recent weekly release. A Vagrant box is then created from the VMWare files. Packer will automatically add the following to the VM:
- A vagrant user
- SSH support
- Chef Client: So that you can deploy your preferred toolset after the box has been created. Check out my <a href="https://github.com/skahwah/chef/tree/master/kali_kitchen">Chef repo</a>
- VMWare tools

This is particularly useful before starting a new pen-testing engagement for a couple of reasons:
- Provisioning a new VM ensures that the cross-contamination of Client data between gigs can't occur
- Starting with the most recent release of Kali ensure that all tools and dependencies are up to date

If you want to create a VM using the Kali full ISO run:
~~~
./build-kali-full.sh
~~~

If you want to create a VM using the Kali light ISO run:
~~~
./build-kali-light.sh
~~~

I've also included a sample Vagrant file.
