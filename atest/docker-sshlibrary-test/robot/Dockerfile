FROM ubuntu:bionic

RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime
RUN sed -i 's;http://archive.ubuntu.com/ubuntu;mirror://mirrors.ubuntu.com/mirrors.txt;' /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends locales net-tools python3-pip python3-setuptools python3-wheel sudo ssh && rm -rf /var/lib/apt/lists/*
RUN sed -i 's,# en_US.UTF-8,en_US.UTF-8,' /etc/locale.gen && locale-gen
RUN pip3 install robotframework robotstatuschecker
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

RUN echo "test ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-test-user

# qwertyuiop
RUN /usr/sbin/useradd -s /bin/bash --password '$6$peaoeqpA$mB0iF3SDkVF71nnD4GQfDN6iknf0AVjf.V8OGY0Lfw.zsgrFEtU0NTj6./TxengGLXZmcBpu9G3uX/sbbullH0' -G sudo -m -U test
USER test
RUN ssh-keygen -f /home/test/.ssh/id_rsa -N ''
RUN echo 'Host test_hostname\n    Hostname front\n' >> /home/test/.ssh/config
RUN echo "export LANG=en_US.UTF-8" >> /home/test/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> /home/test/.bashrc

WORKDIR /robotframework-sshlibrary
ENTRYPOINT /entrypoint.sh
