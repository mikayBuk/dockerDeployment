FROM ubuntu:20.04

# Install necessary packages (if any)
RUN apt-get update && apt-get install -y \
    sudo\
    bash \
    curl  \
    docker.io \ 
    wget \
    fuse \
    systemctl


# Copy your bash script into the container
#COPY installDocker.sh /usr/local/bin/installDocker.sh
COPY installCvmfs.sh /usr/local/bin/installCvmfs.sh

# Make the bash script executable
#RUN chmod +x /usr/local/bin/installDocker.sh
RUN chmod +x /usr/local/bin/installCvmfs.sh


ENV CVMFS_REPOSITORIES=sft.cern.ch,atlas.cern.ch,lhcb.cern.ch,cms.cern.ch,alice.cern.ch,geant4.cern.ch 
ENV CVMFS_HTTP_PROXY=DIRECT

# Set the entrypoint to run the bash script
ENTRYPOINT ["/usr/local/bin/installCvmfs.sh"]
