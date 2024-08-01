# Use an Ubuntu base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Set the PATH to include /usr/games where cowsay and fortune are located
ENV PATH="/usr/games:${PATH}"

# Copy the script into the container
COPY wisecow.sh /app/wisecow.sh

# Set execute permissions on the script
RUN chmod +x /app/wisecow.sh

# Set the default command to run the script
CMD ["/app/wisecow.sh"]
