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

docker cp docker-sshlibrary-test_front_1:/home/test/.ssh/id_rsa atest/testdata/keyfiles/id_rsa
docker cp docker-sshlibrary-test_back_1:/home/test/.ssh/id_rsa atest/testdata/keyfiles/id_rsa_back

jump_target_ip=$(docker inspect -f '{{$network := index .NetworkSettings.Networks "docker-sshlibrary-test_backend"}}{{ $network.IPAddress}}' docker-sshlibrary-test_back_1)

vars="-v HOST:front -v PASSWORD:qwertyuiop -v JH_TARGET_ADDRESS:${jump_target_ip}"
cmd="docker exec -ti docker-sshlibrary-test_robot_1 python3 /robotframework-sshlibrary/atest/run.py ${vars}"

set -x
if [ -n "$1" ];then
    ${cmd} $@
else
    ${cmd} atest/connections.robot
fi
