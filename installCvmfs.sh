#!/bin/bash


#Exit the script whenever there is an error encountered
#set -e

echo "Installing with wget method"

#Create a script that installs and test the installation of cvmfs
echo 'Starting cvmfs installation'

#Getting dependencies
#sudo apt-get install -y systemd 
#sudo apt-get install -y linux-headers-$(uname -r)
#sudo apt-get install -y autofs fuse


# Bypass policy-rc.d restrictions
# echo "Bypassing policy restrictions for autofs"
# echo '#!/bin/sh' | sudo tee /usr/sbin/policy-rc.d
# echo 'exit 0' | sudo tee -a /usr/sbin/policy-rc.d
# sudo chmod +x /usr/sbin/policy-rc.d 


#Adding CVMFS Repo
wget https://cvmrepo.s3.cern.ch/cvmrepo/apt/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get -y update
sudo apt-get -y install cvmfs autofs



#COMMENTING THIS OUT MADE PROBE WORK
# Create and configure autofs service file if missing
# if [ ! -f /etc/systemd/system/autofs.service ]; then
#   sudo tee /etc/systemd/system/autofs.service > /dev/null << EOL
# [Unit]
# Description=Automount File System
# After=network.target local-fs.target

# [Service]
# Type=forking
# ExecStart=/usr/sbin/automount --pid-file /var/run/autofs.pid

# [Install]
# WantedBy=multi-user.target
# EOL
# fi


# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable and start the autofs service
sudo systemctl enable autofs
sudo systemctl start autofs

# Install and load FUSE
echo "***********Installing/Using Fuse***********"
#sudo apt-get install -y fuse
# sudo modprobe fuse
# lsmod | grep fuse

# Check to make sure cvmfs user exists
if id "cvmfs" &>/dev/null; then
    echo "User cvmfs exists."
else
    echo "Creating user cvmfs."
    sudo useradd -m -s /bin/bash cvmfs
fi

# Create the fuse group if it does not exist
if getent group fuse; then
    echo "Group fuse exists."
else
    echo "Creating group fuse."
    sudo groupadd fuse
fi

# Add cvmfs user to fuse group
echo "Adding cvmfs user to fuse group."
sudo usermod -aG fuse cvmfs

# Ensure the /dev/fuse device exists
if [ ! -e /dev/fuse ]; then
    echo "/dev/fuse does not exist. Creating it."
    sudo mknod /dev/fuse -m 0666 c 10 229
else
    echo "/dev/fuse exists."
fi

# Reload group memberships
echo "Reloading group memberships."
newgrp fuse <<EOF
id
EOF

# Change ownership and permissions of /dev/fuse
echo "Setting ownership and permissions for /dev/fuse."
sudo chown root:fuse /dev/fuse
sudo chmod u+rw /dev/fuse
sudo chmod g+rw /dev/fuse

# Verify the groups of cvmfs user
echo "Verifying the groups of cvmfs user."
sudo usermod -aG fuse cvmfs
sudo groups cvmfs
#sudo reboot #Needed to make sure /dev/fuse can be accessed


# FINAL Test access to /dev/fuse as cvmfs user
echo "**********FINAL Testing access to /dev/fuse as cvmfs user.**********"

#Swtich to cvmfs
echo "Opening as cvmfs user"
sudo -u cvmfs test -w /dev/fuse -a -r /dev/fuse  && echo "User can read and write to the file" || echo "User cannot read/write to the file"

# Check the permissions of /dev/fuse
echo "Checking the permissions of /dev/fuse."
ls -l /dev/fuse


echo "***********Basic Setup Required for wget setup***********"
#Create a file that contains the repos, and other env variables
FILENAME="/etc/cvmfs/default.local"
TEXT="CVMFS_REPOSITORIES=sft.cern.ch,atlas.cern.ch\n
CVMFS_HTTP_PROXY=DIRECT\n
CVMFS_CLIENT_PROFILE=single\n
CVMFS_LOGFILE=/var/log/cvmfs.log\n
CVMFS_USE_LOGFILE=yes\n"
if [ ! -f $FILENAME ]; then
  echo -e $TEXT | sudo tee $FILENAME
fi

echo "********Running cvmfs_config setup*********"
echo "12\n4\n" | sudo cvmfs_config setup

#Restarting autofs 
echo "***********Restarting autofs***********"
sudo pkill autofs
sudo systemctl restart autofs


sudo systemctl status autofs


#Verify if the setup was successful
echo "***********Verifying if setup was successful***********"
sudo cvmfs_config probe

# Capture the exit status of the probe command
probe_status=$?
if [ $probe_status -ne 0 ]; then
  echo "cvmfs_config probe failed with exit status $probe_status"
else
  echo "cvmfs_config probe succeeded"
fi
echo "Verification process complete"


#Finished with cvmfs installation
echo '****Finished cvmfs installation*****'

echo "Checking Setup of cvmfs"
sudo cvmfs_config chksetup

# sudo su cvmfs
# whoami 


echo "Switching from root to cvmfs user"
sudo passwd -u cvmfs
sudo usermod -s /bin/bash cvmfs
sudo su cvmfs
