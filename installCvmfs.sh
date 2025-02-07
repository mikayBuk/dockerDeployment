#!/bin/bash

echo "Running container as a system service"

#Create a script that installs and test the installation of cvmfs
echo 'Starting cvmfs installation'

#Installing pre-reqs
apt-get install sudo
sudo apt-get install wget
sudo apt-get install curl


echo "Finish with pre-reqs"

#Upgrading kernel to 


#Adding CVMFS Repo
# wget https://cvmrepo.s3.cern.ch/cvmrepo/apt/cvmfs-release-latest_all.deb
# sudo dpkg -i cvmfs-release-latest_all.deb
# rm -f cvmfs-release-latest_all.deb
# sudo apt-get -y update
# sudo apt-get -y install cvmfs


#Getting cvmfs from docker container - Method 1
echo "Starting with docker-pull command"
docker pull registry.cern.ch/cvmfs/service:latest
echo "Done with docker-pull command"


#echo "Running container as a system service"
# docker run -d --rm \
#   -e CVMFS_CLIENT_PROFILE=single \
#   -e CVMFS_REPOSITORIES=sft.cern.ch,... \
#   --cap-add SYS_ADMIN \
#   --device /dev/fuse \
#   --volume /cvmfs:/cvmfs:shared \
#   cvmfs/service:latest


#Getting cvmfs from docker container - Method 2
# echo "Starting with curl command"
# curl https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.12.0/cvmfs-service-2.12.0.x86_64.docker.tar.gz | docker load
# echo "Done with curl command"




#Basic Setup
# echo "*****Setting up CVMFS - Basic*****"
# # check_kernel()
# KERNEL=$(uname -r)
# echo "Kernel: $KERNEL"


# echo "Checking errors in /etc/fstab" #is not configured
# cat /etc/fstab

#STOPS WORKING HERE
# sudo cvmfs_config setup



#Create /etc/cvmfs/default.local to add repos
#make_default_local()


#Verify if the setup was successful
# echo "Verifying setup was successful"
# sudo cvmfs_config probe

#Finished with cvmfs installation
echo '****Finished cvmfs installation*****'
