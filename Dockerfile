FROM ubuntu:14.04

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Download GHC and cabal
RUN apt-get update && \
    apt-get install -y software-properties-common pkg-config && \
    add-apt-repository -y ppa:hvr/ghc && \
    apt-get update && \
    apt-get install -y cabal-install-1.18 ghc-7.8.3 cpphs \
                       libpcre3 libpcre3-dev mysql-server \
                       libmysqlclient-dev screen \
                       happy-1.19.4 alex-3.1.3 \
                       zlib1g-dev libncurses5-dev && \
    service mysql start && \
    mysqladmin -u root password password && \
    mkdir /development && \
    mkdir /development/init && \
    mkdir /development/bead && \
    mkdir /bead-server

ENV PATH /opt/ghc/7.8.3/bin:/opt/cabal/1.18/bin:/opt/alex/3.1.3/bin:/opt/happy/1.19.4/bin:$PATH

# Copy cabal file and install dependencies
COPY "./bead/Bead.cabal" "/development/init/Bead.cabal"
COPY "./bead/docker/container-script/dev-env-setup.sh" "/development/init/dev-env-setup.sh"
RUN cd development/init && \
    cabal update && \
    cabal install --only-dependencies --reorder-goals

# Directory for sources, running
VOLUME ["/development/bead", "/bead-server"]

# Expose the default port
EXPOSE 8000
