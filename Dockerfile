FROM phusion/baseimage

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
         git \
         automake \
         build-essential \
         libtool \
         autotools-dev \
         autoconf \
         pkg-config \
         libssl-dev \ 
         libboost-all-dev \
         libevent-dev \
         bsdmainutils \
         vim \
         software-properties-common && \
         rm -rf /var/lib/apt/lists/* &&\
         apt-get clean

RUN add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
          libdb4.8-dev \
          libdb4.8++-dev \
          libminiupnpc-dev && \
          rm -rf /var/lib/apt/lists/*  &&\
          apt-get clean

WORKDIR /ips

ENV IPS_VERSION v3.1.0.0

RUN git clone -b master https://github.com/ipsum-network/ips.git . && \
    git checkout $IPS_VERSION && \
    ./autogen.sh && \
    ./configure && \
    make &&\
    strip /ips/src/ipsd /ips/src/ips-cli && \
    mv /ips/src/ipsd /usr/local/bin/ && \
    mv /ips/src/ips-cli /usr/local/bin/ && \
    # clean
    rm -rf /ips 

VOLUME ["/root/.ips"]

EXPOSE 22331

CMD exec ipsd && tail -f /root/.ips/debug.log
