FROM ubuntu:bionic

RUN apt-get update && apt-get install -y openssh-server && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /run/sshd
# qwertyuiop
RUN /usr/sbin/useradd -s /bin/bash --password '$6$peaoeqpA$mB0iF3SDkVF71nnD4GQfDN6iknf0AVjf.V8OGY0Lfw.zsgrFEtU0NTj6./TxengGLXZmcBpu9G3uX/sbbullH0' -G sudo -m -U test
USER test
RUN ssh-keygen -f /home/test/.ssh/id_rsa -N ''
RUN cp /home/test/.ssh/id_rsa.pub /home/test/.ssh/authorized_keys

USER root

CMD /usr/sbin/sshd -D
