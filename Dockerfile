# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM nitrousio/nodejs:latest
MAINTAINER Nitrous.IO <hello@nitrous.io>


# ------------------------------------------------------------------------------
# Install dependencies
RUN apt-get -y install git curl build-essential supervisor g++ libssl-dev libxml2-dev mercurial man tree lsof npm nodejs-legacy

# Install npm
RUN git clone https://github.com/creationix/nvm.git

# ------------------------------------------------------------------------------
# Install nodejs
ENV NODE_VERSION v0.10.29
RUN echo 'source /nvm/nvm.sh && nvm install ${NODE_VERSION}' | bash -l
ENV PATH /nvm/{NODE_VERSION}/bin:${PATH}
RUN npm install -g forever




# ------------------------------------------------------------------------------
# Get cloud9 source and install
RUN git clone http://quarkgit.cloudapp.net/spayyavula/MezzLabsC9.git cloud9
RUN cd /cloud9 && npm install
WORKDIR /cloud9

# ------------------------------------------------------------------------------
# Add workspace volumes
RUN mkdir /cloud9/workspace
VOLUME /cloud9/workspace

# ------------------------------------------------------------------------------
# Set default workspace dir
ENV C9_WORKSPACE /cloud9/workspace

# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 3131

ENV NITROUS_SSH_ENABLED false
ENV NITROUS_APP_PORT 3131

ENV IDE_USERNAME user
ENV IDE_PASSWORD <__random__>



# ------------------------------------------------------------------------------
# copy from kennethkl/cloud9

ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/cloud9/workspace", "-l", "0.0.0.0"]
