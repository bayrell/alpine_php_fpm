#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	docker)
		docker build ./ -t bayrell/alpine_php_fpm:7.3-$TAG --file Dockerfile
		docker tag bayrell/alpine_php_fpm:7.3-$TAG bayrell/alpine_php_fpm:7.3
	;;
	
	*)
		echo "Usage: $0 {docker}"
		RETVAL=1

esac

exit $RETVAL

