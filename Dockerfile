# Use an official Ubuntu base image
FROM ubuntu:latest
# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive
# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*


# Set the working directory
WORKDIR /home/beammpserver
# At this point, you need to have the BeamMP-Server file inside the Docker context and copy it into the image.
# If you have a direct download link, you could use `wget` to download it instead of the COPY command.
COPY BeamMP-Server.ubuntu.22.04.x86_64 /home/beammpserver/BeamMP-Server

COPY entrypoint.sh /home/beammpserver/entrypoint.sh

# OR, for an example with wget (replace `your_direct_download_link` with the actual URL):
# RUN wget -O BeamMP-Server your_direct_download_link
# Make the server executable
RUN chmod +x BeamMP-Server



# Expose the necessary ports (adjust these according to your BeamMP Server configuration)
# For example, if your BeamMP Server listens on 30814 TCP/UDP
EXPOSE 30814/tcp 30814/udp
# Set the container to run the BeamMP server by default
ENTRYPOINT ["./BeamMP-Server"]






# Use Ubuntu as base image
FROM ubuntu:latest
# Update package lists and install SSH server and fail2ban
RUN apt-get update && \
    apt-get install -y openssh-server fail2ban && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Copy custom fail2ban configuration
COPY jail.local /etc/fail2ban/jail.local

# Set the working directory
WORKDIR /home/beammpserver
# At this point, you need to have the BeamMP-Server file inside the Docker context and copy it into the image.
# If you have a direct download link, you could use `wget` to download it instead of the COPY command.
COPY BeamMP-Server.ubuntu.22.04.x86_64 /home/beammpserver/BeamMP-Server

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh

# OR, for an example with wget (replace `your_direct_download_link` with the actual URL):
# RUN wget -O BeamMP-Server your_direct_download_link
# Make the server executable
RUN chmod +x BeamMP-Server


# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
