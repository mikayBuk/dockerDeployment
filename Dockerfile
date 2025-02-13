FROM ubuntu:20.04

#COPY docker-compose.yml docker-compose.yml

# Install necessary packages (if any)
RUN apt-get update && apt-get install -y \
    sudo \    
    bash \
    curl  \
    docker.io



#RUN docker-compose up -d

#RUN docker pull registry.cern.ch/cvmfs/service:latest

# RUN docker run -d --rm \
#   -e CVMFS_CLIENT_PROFILE=single \
#   -e CVMFS_REPOSITORIES=sft.cern.ch \
#   --cap-add SYS_ADMIN \
#   --device /dev/fuse \
#   --volume /cvmfs:/cvmfs:shared \
#   registry.cern.ch/cvmfs/service:latest


# Copy your bash script into the container
COPY installDocker.sh /usr/local/bin/installDocker.sh
COPY installCvmfs.sh /usr/local/bin/installCvmfs.sh

# Make the bash script executable
RUN chmod +x /usr/local/bin/installDocker.sh
RUN chmod +x /usr/local/bin/installCvmfs.sh

# Set the entrypoint to run the bash script
ENTRYPOINT ["/usr/local/bin/installCvmfs.sh"]
