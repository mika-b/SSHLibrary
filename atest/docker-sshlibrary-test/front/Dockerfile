FROM ubuntu:xenial

RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime
RUN sed -i 's;http://archive.ubuntu.com/ubuntu;mirror://mirrors.ubuntu.com/mirrors.txt;' /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends inetutils-ping locales openssh-server sudo && rm -rf /var/lib/apt/lists/*
RUN sed -i 's,# en_US.UTF-8,en_US.UTF-8,' /etc/locale.gen && locale-gen
RUN mkdir -p /run/sshd

# Create user test with password test
RUN /usr/sbin/useradd -s /bin/bash --password '$6$Vx6rGoWK$Y6qLJrBkKnEgb59273zkixZsS4BZk2QYJvth3e2wSEfH0Z1P6BVtSegjoK70oAOYS.tudfGuoog1g9UAuR.ju/' -G sudo -m -U test
USER test
RUN echo "export PS1='\u@\h \W \$ '" >> /home/test/.bashrc
RUN echo "export LANG=en_US.UTF-8" >> /home/test/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> /home/test/.bashrc

# Create user testkey with password test
USER root
RUN /usr/sbin/useradd -s /bin/bash --password '$6$Vx6rGoWK$Y6qLJrBkKnEgb59273zkixZsS4BZk2QYJvth3e2wSEfH0Z1P6BVtSegjoK70oAOYS.tudfGuoog1g9UAuR.ju/' -G sudo -m -U testkey
USER testkey
RUN ssh-keygen -f /home/testkey/.ssh/id_rsa -N ''
RUN cp /home/testkey/.ssh/id_rsa.pub /home/testkey/.ssh/authorized_keys
RUN echo "export PS1='\u@\h \W \$ '" >> /home/testkey/.bashrc
RUN echo "export LANG=en_US.UTF-8" >> /home/testkey/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> /home/testkey/.bashrc

USER root
RUN echo "Testing pre-login banner" >> /etc/ssh/sshd-banner
RUN echo "Banner /etc/ssh/sshd-banner" >> /etc/ssh/sshd_config
RUN echo 'Subsystem subsys echo "Subsystem invoked."' >> /etc/ssh/sshd_config
CMD /usr/sbin/sshd -D
