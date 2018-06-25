FROM centos:latest

LABEL Author="Sergey Antonov asera79@gmail.com"

ENV METEOR_ALLOW_SUPERUSER true
ENV MONGO_URL "mongodb://admin:secret@mongodb:27017"

RUN yum -y update && \
    yum install -y sudo && \
    curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash - && \
    sudo yum -y install nodejs && \
    sudo yum -y install gcc-c++ make && \
    curl https://install.meteor.com/ | sh

WORKDIR /opt/app

ENTRYPOINT [ "meteor" ]