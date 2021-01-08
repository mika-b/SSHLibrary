FROM ubuntu:xenial

RUN apt-get update && apt-get install -y openssh-server && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /run/sshd
# Create user test with password test
RUN /usr/sbin/useradd -s /bin/bash --password '$6$Vx6rGoWK$Y6qLJrBkKnEgb59273zkixZsS4BZk2QYJvth3e2wSEfH0Z1P6BVtSegjoK70oAOYS.tudfGuoog1g9UAuR.ju/' -G sudo -m -U test
USER test
RUN echo "export PS1='\u@\h \W \$ '" >> /home/test/.bashrc
RUN echo "export LANG=en_US.UTF-8" >> /home/test/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> /home/test/.bashrc

USER root
RUN /usr/sbin/useradd -s /bin/bash --password '$6$Vx6rGoWK$Y6qLJrBkKnEgb59273zkixZsS4BZk2QYJvth3e2wSEfH0Z1P6BVtSegjoK70oAOYS.tudfGuoog1g9UAuR.ju/' -G sudo -m -U testkey
USER testkey
RUN ssh-keygen -f /home/testkey/.ssh/id_rsa -N ''
RUN install -m 600 -o testkey -g testkey /home/testkey/.ssh/id_rsa.pub /home/testkey/.ssh/authorized_keys
RUN echo "export PS1='\u@\h \W \$ '" >> /home/testkey/.bashrc
RUN echo "export LANG=en_US.UTF-8" >> /home/testkey/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> /home/testkey/.bashrc

USER root

CMD /usr/sbin/sshd -D
