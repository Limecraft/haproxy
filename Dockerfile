#
# Haproxy Dockerfile
#
# based on https://github.com/dockerfile/haproxy
#

# Pull base image.
# Pull base image.
FROM dockerfile/ubuntu

# Install Haproxy.
RUN \
  add-apt-repository ppa:vbernat/haproxy-1.5 && \
  apt-get update && apt-get upgrade &&\
  sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD start.bash /haproxy-start

# Define mountable directories.
VOLUME ["/haproxy-override"]

# Define working directory.
WORKDIR /etc/haproxy

# Define default command.
CMD ["bash", "/haproxy-start"]

EXPOSE 22 80 443 6667 22002
 
