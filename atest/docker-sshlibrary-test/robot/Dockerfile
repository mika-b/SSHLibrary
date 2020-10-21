FROM ubuntu:bionic

RUN ln -fs /usr/share/zoneinfo/Europe/Helsinki /etc/localtime
RUN apt-get update && apt-get install -y python3-pip ssh && rm -rf /var/lib/apt/lists/*
RUN pip3 install robotframework robotstatuschecker
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# qwertyuiop
RUN /usr/sbin/useradd -s /bin/bash --password '$6$peaoeqpA$mB0iF3SDkVF71nnD4GQfDN6iknf0AVjf.V8OGY0Lfw.zsgrFEtU0NTj6./TxengGLXZmcBpu9G3uX/sbbullH0' -G sudo -m -U test
USER test
RUN ssh-keygen -f /home/test/.ssh/id_rsa -N ''

WORKDIR /robotframework-sshlibrary
ENTRYPOINT /entrypoint.sh
