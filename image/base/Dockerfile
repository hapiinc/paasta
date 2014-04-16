# Docker 0.10.0, build dc9c28f
# Image paasta/base

FROM ubuntu:latest
MAINTAINER Tony Tahmouch <ttahmouch@gmail.com>

# Prepare Base Stack
RUN su - root -c "apt-get update && \
                  apt-get install -q -y git make openssh-server supervisor nano vim curl socat wget \
                                        python-software-properties software-properties-common python g++ \
                                        build-essential && \
                  curl http://nodejs.org/dist/v0.10.26/node-v0.10.26.tar.gz | tar zx node-v0.10.26  && \
                  cd node-v0.10.26 && ./configure && make && make install && \
                  npm install --unsafe-perm -g codebox forever"

# Prepare Git
ADD git-shell-commands/ /root/git-shell-commands/
ADD hooks/ /root/.git-templates/hooks/
RUN su - root -c "mkdir -p app && \
                  git-shell-commands/git --add app.git"

# Prepare Supervisor and SSH Daemons
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/
ADD ssh/sshd_config.awk /etc/ssh/
RUN su - root -c "mkdir -p /var/log/supervisor && \
                  mkdir -p /var/run/sshd && \
                  cat /etc/ssh/sshd_config | awk -f /etc/ssh/sshd_config.awk > /etc/ssh/sshd_config"

# Bootstrap
ENV HOME /root
EXPOSE 22 80 8080
CMD ["/usr/bin/supervisord"]
