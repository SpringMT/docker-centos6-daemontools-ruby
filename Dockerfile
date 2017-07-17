# CentOS
#
# VERSION               0.0.1

FROM     centos:centos6

MAINTAINER Spring_MT

ENV MYSQL_RPM_VERSION mysql-community-release-el6-5.noarch.rpm

RUN yum install -y \
    zip \
    unzip \
    epel-release \
    openssl \
    ca-certificates \
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

# mysql
RUN yum install -y http://repo.mysql.com/mysql-community-release-el5-5.noarch.rpm
RUN yum install -y mysql-community-server mysql-community-devel mysql-community-client

# rbenv and ruby
RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
&&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
&&  git clone git://github.com/jf/rbenv-gemset.git /usr/local/rbenv/plugins/rbenv-gemset \
&&  /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV CONFIGURE_OPTS --disable-install-doc
ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

RUN eval "$(rbenv init -)"; rbenv install 2.3.1 \
&&  eval "$(rbenv init -)"; rbenv global 2.3.1 \
&&  eval "$(rbenv init -)"; gem update --system \
&&  eval "$(rbenv init -)"; gem install bundler

