#!/usr/bin/env bash

usage() {
    echo -e "Build containers and start test environment with:
cd atest/docker-sshlibrary-test
docker-compose up\n"
    echo -e "Shut it down with 'ctrl-c' and remove with 'docker-compose down'\n"
}

if ! docker ps | grep -q docker-sshlibrary-test_front_1;then
    echo -e "Test environment not running\n"
    usage
    exit 1
fi

docker cp docker-sshlibrary-test_robot_1:/home/test/.ssh/id_rsa atest/testdata/keyfiles/id_rsa
docker cp docker-sshlibrary-test_back_1:/home/testkey/.ssh/id_rsa atest/testdata/keyfiles/id_rsa_back

docker cp docker-sshlibrary-test_robot_1:/home/test/.ssh/id_rsa.pub id_rsa.pub.temp
docker cp id_rsa.pub.temp docker-sshlibrary-test_front_1:/home/testkey/.ssh/authorized_keys
docker exec docker-sshlibrary-test_front_1 chmod 600 /home/testkey/.ssh/authorized_keys
docker exec docker-sshlibrary-test_front_1 chown testkey: /home/testkey/.ssh/authorized_keys

jump_target_ip=$(docker inspect -f '{{$network := index .NetworkSettings.Networks "docker-sshlibrary-test_backend"}}{{ $network.IPAddress}}' docker-sshlibrary-test_back_1)
environment=$(docker exec -ti docker-sshlibrary-test_robot_1 ssh-agent)
SOCK=$(echo "$environment" | grep -Eo "SSH_AUTH_SOCK=[a-zA-Z0-9/\.-]*")
PID=$(echo "$environment" | grep -Eo "SSH_AGENT_PID=[a-zA-Z0-9/\.-]*")
vars="-v DOCKER:True -v HOST:front -v JH_TARGET_ADDRESS:${jump_target_ip}"

# add key to agent
# docker exec -e $SOCK -e $PID -ti docker-sshlibrary-test_robot_1 ssh-add /home/test/.ssh/id_rsa

cmd="docker exec -e LC_ALL=en_US.UTF-8 -e $SOCK -e $PID -ti docker-sshlibrary-test_robot_1 python3 /robotframework-sshlibrary/atest/run.py ${vars}"

set -x
if [ -n "$1" ];then
    ${cmd} $@
else
    ${cmd} atest/connections.robot
fi

docker exec -e $SOCK -e $PID -ti docker-sshlibrary-test_robot_1 ssh-agent -k
