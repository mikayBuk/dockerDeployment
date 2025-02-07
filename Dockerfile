FROM ubuntu:20.04

# Install necessary packages (if any)
RUN apt-get update && apt-get install -y \
    bash \
    curl  # You can add other packages here


# Copy your bash script into the container
#COPY installDocker.sh /usr/local/bin/installDocker.sh
COPY installCvmfs.sh /usr/local/bin/installCvmfs.sh

# Make the bash script executable
#RUN chmod +x /usr/local/bin/installDocker.sh
RUN chmod +x /usr/local/bin/installCvmfs.sh

# Set the entrypoint to run the bash script
ENTRYPOINT ["/usr/local/bin/installCvmfs.sh"]
