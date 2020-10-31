#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=1
TAG=`date '+%Y%m%d_%H%M%S'`
#linux/arm64/v8,

case "$1" in
	
	docker)
		docker build ./ -t bayrell/alpine_php_fpm:7.3-$TAG --file Dockerfile
		docker tag bayrell/alpine_php_fpm:7.3-$TAG bayrell/alpine_php_fpm:7.3
	;;
	
	multi)
		docker buildx build --platform linux/arm/v7,linux/amd64 \
			--tag bayrell/alpine_php_fpm:7.3-$VERSION --file Dockerfile .
	;;
	
	*)
		echo "Usage: $0 {docker|multi}"
		RETVAL=1

esac

exit $RETVAL

