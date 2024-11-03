#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Container must be run as root"
  exit 1
fi

echo "Start container"

export EDITOR=nano

# Run scripts
if [ -d /root/run.d ]; then
  for i in /root/run.d/*.sh; do
    if [ -f $i ]; then
      . $i
    fi
  done
  unset i
fi

#/usr/sbin/php-fpm83
#/usr/sbin/nginx
#bash

/root/main.py

#wait 1
#sleep 2
#echo "Shutdown container"

trap 'echo Shutdown container; exit 0' TERM SIGHUP SIGINT SIGQUIT SIGTERM
#tail -f /dev/null
#while true; do
#  echo "`date`"
#  sleep 1
#done

# Run container
#trap 'kill -TERM $PID; wait $PID' SIGHUP SIGINT SIGQUIT SIGTERM
#/root/main.py &
#PID=$!
#wait $PID
#wait $PID
#EXIT_STATUS=$?
#sleep 2
#echo "Shutdown container"

#trap 'echo "Shutdown container"' EXIT; tail -f /dev/null

# Run supervisor
#trap 'kill -TERM $PID; wait $PID' SIGHUP SIGINT SIGQUIT SIGTERM
#rm -f /var/run/supervisor/supervisor.sock
#/usr/bin/supervisord -c /etc/supervisord.conf -n &
#PID=$!
#wait $PID
#wait $PID
#EXIT_STATUS=$?
#sleep 2
#echo "Shutdown container"