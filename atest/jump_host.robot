*** Settings ***
Default Tags     pybot
Library        OperatingSystem
Resource       resources/common.robot
Test Teardown  Close All Connections

*** Variables ***
${KEY DIR}           ${LOCAL TESTDATA}${/}keyfiles
${KEY}               ${KEY DIR}${/}id_rsa
${JH_ADDRESS}        front
${JH_USERNAME}       test
${JH_USERNAME_KEY}   testkey
${JH_PASSWORD}       test

# ADDRESS set in atest/run-in-docker.sh
${JH_TARGET_ADDRESS}       ${EMPTY}
${JH_TARGET_USERNAME}      test
${JH_TARGET_USERNAME_KEY}  testkey
${JH_TARGET_PASSWORD}      test

*** Test Cases ***
Attempting To Connect Directly Should Fail
    Open Connection  ${JH_TARGET_ADDRESS}
    Run Keyword And Expect Error  timeout*  Login  ${JH_TARGET_USERNAME}  ${JH_TARGET_PASSWORD}
    [Teardown]  Close All Connections

Attempting To Use Jumphost And Proxy At The Same Time Should Fail
    Open Connection  ${JH_ADDRESS}  alias=jumphost
    Login  ${JH_USERNAME}  ${JH_PASSWORD}

    Open Connection  ${JH_TARGET_ADDRESS}
    Run Keyword And Expect Error  ValueError*  Login  ${JH_TARGET_USERNAME}  ${JH_TARGET_PASSWORD}  jumphost_index_or_alias=jumphost  proxy_cmd=echo

    [Teardown]  Close All Connections

Connect Via Jump Host Using Password Authentication
    Open Connection  ${JH_ADDRESS}  alias=jumphost
    Login  ${JH_USERNAME}  ${JH_PASSWORD}

    Open Connection  ${JH_TARGET_ADDRESS}
    Login  ${JH_TARGET_USERNAME}  ${JH_TARGET_PASSWORD}  jumphost_index_or_alias=jumphost
    ${out}=  Execute Command  env

    [Teardown]  Close All Connections

Connect Via Jump Host Using Key Authentication
    Open Connection  ${JH_ADDRESS}  alias=jumphost
    Login With Public Key  ${JH_USERNAME_KEY}  keyfile=${KEY}

    Open Connection  ${JH_TARGET_ADDRESS}
    Login With Public Key  ${JH_USERNAME_KEY}  keyfile=${KEYDIR}${/}id_rsa_back  jumphost_index_or_alias=jumphost
    ${out}=  Execute Command  env
