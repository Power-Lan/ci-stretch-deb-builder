FROM debian:stretch
MAINTAINER William MARTIN <william.martin@power-lan.com>

ENV DEBIAN_FRONTEND noninteractive

# Up-to-date the system
RUN apt-get update && apt-get upgrade --yes --force-yes

# Install gitlab runner
RUN apt-get install -y curl
RUN curl -L https://packages.gitlab.com/runner/gitlab-ci-multi-runner/gpgkey | apt-key add -
RUN apt-get install -y debian-archive-keyring apt-transport-https
COPY gitlab-runner.list /etc/apt/sources.list.d
RUN apt-get update
RUN apt-get install -y gitlab-ci-multi-runner
VOLUME /etc/gitlab-runner

# Install Dev tools
RUN apt-get install -y locales sudo git packaging-dev

# Reconfigure locale
RUN locale-gen en_US.UTF-8 fr_FR.UTF-8 && dpkg-reconfigure locales

# Add group & user
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user
USER user
VOLUME /home/user
WORKDIR /home/user

