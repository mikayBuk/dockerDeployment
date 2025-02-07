#!/bin/bash

#Create a script that installs and test the installation of cvmfs
echo 'Starting cvmfs installation'

#Installing pre-reqs
apt-get install sudo
sudo apt-get install wget

#Upgrading kernel to 


#Adding CVMFS Repo
wget https://cvmrepo.s3.cern.ch/cvmrepo/apt/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get -y update
sudo apt-get -y install cvmfs




#Basic Setup
echo "*****Setting up CVMFS - Basic*****"
# check_kernel()
KERNEL=$(uname -r)
echo "Kernel: $KERNEL"


echo "Checking errors in /etc/fstab" #is not configured
cat /etc/fstab

#STOPS WORKING HERE
sudo cvmfs_config setup



#Create /etc/cvmfs/default.local to add repos
#make_default_local()


#Verify if the setup was successful
echo "Verifying setup was successful"
sudo cvmfs_config probe

#Finished with cvmfs installation
echo '****Finished cvmfs installation*****'
