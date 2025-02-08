# dockerDeployment
Created: 1/29/25

This is supposed to be a repo for deploying a container on a new device with cvmfs and docker ready.

There are two bash scripts: installCvmfs.sh and installDocker.sh. 

installCvmfs.sh installs cvmfs in the docker container. It obtains the pre-reqs (wget, sudo) before 
setting up cvmfs. Follows the instructions on the page for debuntu setups (https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html).

Getting docker to run cvmfs right now. Using the docker pull method. Right now, creates two docker containers, one nested in another. The nested containder contains the cvmfs tool. having trouble accessing the nested container, since the container exits after creation. 

installDocker.sh installs docker in the containder. Follows the instructions on the page for debuntu setups (https://docs.docker.com/engine/install/ubuntu/#uninstall-old-versions).