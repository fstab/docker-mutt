FROM ubuntu:14.10
MAINTAINER Fabian Stäber, fabian@fstab.de

RUN apt-get update && \
    apt-get upgrade -y

# Set the locale (I want to use German Umlauts)
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the timezone (change this to your local timezone)
RUN echo "Europe/Berlin" | tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y \
    msmtp \
    mutt \
    vim

RUN adduser --disabled-login --gecos '' mutt
WORKDIR /home/mutt
USER mutt

ENTRYPOINT /bin/bash -c 'if [ -f ~/.muttrc -a -f ~/.msmtprc ] ; then /usr/bin/mutt ; else echo "ERROR: /home/mutt/.muttrc or /home/mutt/.msmtprc not found." ; fi'
