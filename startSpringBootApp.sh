#!/bin/bash

####
# This script is used to stop and start a spring boot application.
# It looks for the existing .pid file created by spring boot and kills process before
# starting new version.
#
# This is particularly useful when combined with jenkins.
# See: Publish over SSH jenkins plugin.
#
# David Key 2016. No rights reserved.
# https://github.com/davidkey
####

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

LOG=`pwd`
LOG="$LOG/startSpringBootApp.log"

echo "Starting @ " `date` | tee -a $LOG

if [ "$#" -ne 1 ]; then
        echo "Wrong arguments! Requires 1 argument [APPLICATION_NAME]" >&2
        exit 1
fi

APPLICATION_NAME=$1
echo "APPLICATION_NAME: $APPLICATION_NAME" | tee -a $LOG

#PID_FILE="./$APPLICATION_NAME/$APPLICATION_NAME.pid"
PID_FILE=`find ./$APPLICATION_NAME/*.pid`
echo "PID_FILE: $PID_FILE"

if [ -f "$PID_FILE" ]; then
        echo "pid file exists - killing existing process" | tee -a "$LOG"
        kill -9 `cat $PID_FILE` | tee -a $LOG
fi

cd "$APPLICATION_NAME"
JAR_LOCATION="./$APPLICATION_NAME.jar"

if [ ! -f "$JAR_LOCATION" ]; then
        echo "Expected jar does not exist: $JAR_LOCATION" >&2
        exit 1
fi

# see https://stackoverflow.com/questions/28500066/how-to-deploy-springboot-maven-application-with-jenkins
echo "EXECUTING: \"nohup nice java -jar \"$JAR_LOCATION\" --spring.profiles.active=dev --server.contextPath=/$APPLICATION_NAME >$SCRIPT_DIR/$APPLICATION_NAME/nohup.out 2>&1 &\""
echo "nohup nice java -jar \"$JAR_LOCATION\" --spring.profiles.active=dev --server.contextPath=/$APPLICATION_NAME >$SCRIPT_DIR/$APPLICATION_NAME/nohup.out 2>&1 &" | at now

echo "Done @ " `date` | tee -a $LOG
