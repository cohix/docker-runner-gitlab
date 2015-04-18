FROM spottedu/docker-runner-base:latest
MAINTAINER connor@spottedu.co

RUN apt-get update && \
    apt-get install -y build-essential cmake openssh-server \
      ruby2.1-dev libmysqlclient-dev zlib1g-dev libyaml-dev libssl-dev \
      libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
      libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
      mysql-server mysql-client redis-server fontconfig && \
    gem install --no-document bundler && \
    rm -rf /var/lib/apt/lists/* # 20150323

ADD assets/ /app/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

# Set ENV's
ENV CI_SERVER_URL=http://ci.spottedu.co/
ENV REGISTRATION_TOKEN=4fb1d38eabcd39203214

# Install node
RUN sudo apt-get update
RUN sudo apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN sudo apt-get install -y nodejs

# Install mongo
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN sudo apt-get update
RUN sudo apt-get install -y mongodb-org
RUN sudo apt-get install -y mongodb-org=3.0.2 mongodb-org-server=3.0.2 mongodb-org-shell=3.0.2 mongodb-org-mongos=3.0.2 mongodb-org-tools=3.0.2
RUN sudo service mongod start

# Install forever
RUN sudo npm install -g forever

# Allow runner user to use sudo
RUN sudo usermod -a -G sudo gitlab_ci_runner
RUN sudo echo "%sudo  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/spottedu
