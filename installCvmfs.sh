#!/bin/bash

echo "Installing with wget method"

#Create a script that installs and test the installation of cvmfs
echo 'Starting cvmfs installation'

#Getting dependencies
sudo apt-get install linux-headers-$(uname -r)
sudo apt-get install -y autofs fuse


# Bypass policy-rc.d restrictions
echo "Bypassing policy restrictions for autofs"
echo '#!/bin/sh' | sudo tee /usr/sbin/policy-rc.d
echo 'exit 0' | sudo tee -a /usr/sbin/policy-rc.d
sudo chmod +x /usr/sbin/policy-rc.d 


#Adding CVMFS Repo
wget https://cvmrepo.s3.cern.ch/cvmrepo/apt/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get -y update
sudo apt-get -y install cvmfs


# Create and configure autofs service file if missing
if [ ! -f /etc/systemd/system/autofs.service ]; then
  sudo tee /etc/systemd/system/autofs.service > /dev/null << EOL
[Unit]
Description=Automount File System
After=network.target local-fs.target

[Service]
Type=forking
ExecStart=/usr/sbin/automount --pid-file /var/run/autofs.pid

[Install]
WantedBy=multi-user.target
EOL
fi


# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable and start the autofs service
sudo systemctl enable autofs
sudo systemctl start autofs

# Install and load FUSE
sudo apt-get install --reinstall -y fuse
ls /lib/modules/$(uname -r)/kernel/fs/fuse/
sudo modprobe fuse

# Add cvmfs user to fuse group and set permissions
sudo groupadd fuse
sudo usermod -aG fuse cvmfs

if [ ! -e /dev/fuse ]; then
  sudo mknod /dev/fuse -m 0666 c 10 229
else
  sudo chown root:fuse /dev/fuse
  sudo chmod 0660 /dev/fuse
fi

#STOPS WORKING HERE
echo "Basic Setup Required for wget setup"
printf "12\n4\n" | sudo cvmfs_config setup

#Create a file that contains the repos, and other env variables
FILENAME="/etc/cvmfs/default.local"
TEXT="CVMFS_REPOSITORIES=atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch
CVMFS_HTTP_PROXY=DIRECT
CVMFS_CLIENT_PROFILE=single"
echo "$TEXT" > $FILENAME

#Restarting autofs 
echo "Restarting autofs"
sudo pkill autofs
sudo systemctl restart autofs


sudo systemctl status autofs


#Verify if the setup was successful
echo "Verifying if setup was successful"
sudo cvmfs_config probe

# Capture the exit status of the probe command
probe_status=$?
if [ $probe_status -ne 0 ]; then
  echo "cvmfs_config probe failed with exit status $probe_status"
else
  echo "cvmfs_config probe succeeded"
fi
echo "Verification process complete"


sudo cvmfs_config chksetup


#Finished with cvmfs installation
echo '****Finished cvmfs installation*****'