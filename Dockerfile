# # First stage: Use the CVMFS base image
# FROM registry.cern.ch/cvmfs/service:latest AS cvmfs_stage

# # Perform any tasks or install additional packages
# RUN echo "Setting up CVMFS stage"

# # Second stage: Use the Ubuntu base image
# FROM ubuntu:latest AS ubuntu_stage

# # Perform any tasks or install additional packages
# RUN apt-get update && apt-get install -y curl

# # Final stage: Use Ubuntu as the base and copy components from both stages
# FROM ubuntu:latest

# # Copy files from the CVMFS stage
# COPY --from=cvmfs_stage /path/from/cvmfs /path/in/final

# # Copy files from the Ubuntu stage
# COPY --from=ubuntu_stage /path/from/ubuntu /path/in/final

# # Additional customizations for the final image
# RUN echo "Setting up the final image"


#COPY docker-compose.yml docker-compose.yml

# Install necessary packages (if any)
# RUN apt-get update && apt-get install -y \
#     sudo \    
#     bash \
#     curl  \
#     systemctl \
#     docker.io



#RUN docker-compose up -d

# RUN docker pull registry.cern.ch/cvmfs/service:latest

# RUN docker run -d --rm \
#   -e CVMFS_CLIENT_PROFILE=single \
#   -e CVMFS_REPOSITORIES=sft.cern.ch \
#   --cap-add SYS_ADMIN \
#   --device /dev/fuse \
#   --volume /cvmfs:/cvmfs:shared \
#   registry.cern.ch/cvmfs/service:latest


# Copy your bash script into the container
# COPY installCvmfs.sh /usr/local/bin/installCvmfs.sh
# COPY testEntry.sh /usr/local/bin/testEntry.sh

# # Make the bash script executable
# #RUN chmod +x /usr/local/bin/installDocker.sh
# RUN chmod +x /usr/local/bin/installCvmfs.sh
# RUN chmod +x /usr/local/bin/testEntry.sh

# # Set the entrypoint to run the bash script
# ENTRYPOINT ["/usr/local/bin/testEntry.sh"]


# FROM ubuntu:latest

# RUN apt-get update
# RUN apt-get install -y sudo \
# systemctl \
# docker.io

# Use the CVMFS base image
FROM registry.cern.ch/cvmfs/service:latest

# Add your customizations here
# RUN apt-get update 

# RUN apt-get install -y docker.io \
#     sudo \
#     systemctl
