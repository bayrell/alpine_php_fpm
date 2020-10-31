#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=1
TAG=`date '+%Y%m%d_%H%M%S'`
#linux/arm64/v8,

case "$1" in
	
	build)
		docker build ./ -t bayrell/alpine_php_fpm:7.3-$TAG --file Dockerfile
		docker tag bayrell/alpine_php_fpm:7.3-$TAG bayrell/alpine_php_fpm:7.3
	;;
	
	amd64)
		docker build ./ -t bayrell/alpine_php_fpm:7.3-$VERSION-amd64 --file Dockerfile --build-arg ARCH=amd64/
		docker push bayrell/alpine_php_fpm:7.3-$VERSION-amd64
	;;
	
	arm32v7)
		docker build ./ -t bayrell/alpine_php_fpm:7.3-$VERSION-arm32v7 --file Dockerfile --build-arg ARCH=arm32v7/
		docker push bayrell/alpine_php_fpm:7.3-$VERSION-amd64
	;;
	
	manifest)
		docker manifest create bayrell/alpine_php_fpm:7.3-$VERSION \
			--amend bayrell/alpine_php_fpm:7.3-$VERSION-amd64 \
			--amend bayrell/alpine_php_fpm:7.3-$VERSION-arm32v7
		docker manifest push bayrell/alpine_php_fpm:7.3-$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {build|amd64|arm32v7|manifest|all}"
		RETVAL=1

esac

exit $RETVAL

