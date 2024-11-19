# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

ENV DISPLAY=host.docker.internal:0
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages
RUN apt update && apt install -y \
    sudo \
    nano \
    git \
    python3 \
    build-essential \
    libssl-dev \
    python3-pip \
    wget \
    openssh-client \
    cmake \
    net-tools \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# Accept build arguments with default values
ARG USERNAME=default
ARG PASSWORD=default

# Create a new user and set up sudo privileges
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME


# Set the new user as the default user
USER $USERNAME
WORKDIR /home/$USERNAME


# Default command to run when the container starts
CMD ["bash"]
