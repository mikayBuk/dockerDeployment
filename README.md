# dockerDeployment
Created: 1/29/25

This is supposed to be a repo for deploying a container on a new device with cvmfs and docker ready.

There are two bash scripts: installCvmfs.sh and installDocker.sh. 

installCvmfs.sh installs cvmfs in the docker container. It obtains the pre-reqs (wget, sudo) before 
setting up cvmfs. Follows the instructions on the page for debuntu setups (https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html).
It installs cvmfs using the wget method. Right now, Geo-API is not working. Need to figure out why (maybe need a proxy server?)


To prevent priveledged mode from being overused/misused, user is immediately switched from root to cvmfs after unlocking.

Questions: 
Should I run this in priveledged mode? --> Yes Continue, No, figure out another way
Should I keep them as root or switch to cvmfs user or something else?
Why is GEO-API not working? Ideas: Proxy-server


/dev/fuse can be read only if the container runs in priveleged mode
autofs works if in priveleged mode

Use this command to build the container:
docker build -t cvmfs-wget . 

Use this command to run the container (priveledged mode)
docker run -it --rm --privileged  --mount type=bind,source=/lib/modules/6.8.0-51-generic/kernel/fs/fuse/,target=/lib/modules/6.8.0-51-generic/fuse/ cvmfs-wget 




Getting docker to run cvmfs right now. Using the docker pull method. Right now, creates two docker containers, one nested in another. The nested containder contains the cvmfs tool. having trouble accessing the nested container, since the container exits after creation. 

installDocker.sh installs docker in the containder. Follows the instructions on the page for debuntu setups (https://docs.docker.com/engine/install/ubuntu/#uninstall-old-versions).