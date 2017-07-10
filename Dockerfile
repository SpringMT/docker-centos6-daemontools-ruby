# CentOS
#
# VERSION               0.0.1

FROM     centos:centos6

MAINTAINER Spring_MT

#RUN rpm -ivh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum install -y \
    epel-release \
    openssl-devel \
    readline-devel\
    zlib-devel \
    wget \
    curl \
    git \
    vim \
    tar \
    ImageMagick \
    ImageMagick-devel \
    libffi-devel \
    mysql \
    mysql-devel \
    libxslt-devel \
    redis \
    python \
&&  yum groupinstall "Development Tools" -y \
&&  yum clean all

# node.js LTS install
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - \
    && yum -y install nodejs \
    && npm -g up

# daemontools
RUN mkdir -p /package && chmod 1755 /package && cd /package \
&& wget  http://cr.yp.to/daemontools/daemontools-0.76.tar.gz \
&& tar -xpf daemontools-0.76.tar.gz \
&& rm -f daemontools-0.76.tar.gz \
&& cd /package/admin/daemontools-0.76 \
&& wget http://www.qmail.org/moni.csi.hu/pub/glibc-2.3.1/daemontools-0.76.errno.patch \
&& patch -p1 < daemontools-0.76.errno.patch \
&& echo "patch has done" \
&& echo 'gcc -O2 -Wimplicit -Wunused -Wcomment -Wchar-subscripts -Wuninitialized -Wshadow -Wcast-qual -Wcast-align -Wwrite-strings --include /usr/include/errno.h' > src/conf-cc \
&& package/install \
&& mkdir -p /service && chmod 1755 /service

