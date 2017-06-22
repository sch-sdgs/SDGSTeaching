#!/usr/bin/env bash

USER_LIST=$1
PORT_START=$2

PORT=PORT_START
while read USER; do
    ufw allow ${PORT}
    if [ $? ! -eq 1 ]; then
        exit $?
    fi
    docker run -p ${PORT}:22 -v /sdgs/reference:/reference_files:ro -v /sdgs/teaching/personal_storage/${USER}:/home/stpuser -v /sdgs/teaching/example_fastqs:/example_fastqs:ro --name ${USER} -dit bioinfo_rotation bash /startup.sh
    if [ $? ! -eq 1 ]; then
        exit $?
    fi
    echo "${USER}'s docker is now running on 10.182.155.27:${PORT}"
    PORT=`expr $PORT + 1`

done < $USER_LIST