# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and Apptainer
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository -y ppa:apptainer/ppa \
    && apt-get update && apt-get install -y \
    apptainer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to the mounted volume path
WORKDIR /data

# Default command
CMD ["/bin/bash"]