#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=5.6
SUBVERSION=10
IMAGE_NAME="bayrell/alpine_php_fpm"
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	test)
		docker build ./ -t $IMAGE_NAME:$VERSION.$SUBVERSION-$TAG
			--file Dockerfile --build-arg ARCH=-amd64
		docker tag $IMAGE_NAME:$VERSION.$SUBVERSION-$TAG $IMAGE_NAME:$VERSION.$SUBVERSION
		docker tag $IMAGE_NAME:$VERSION.$SUBVERSION-$TAG $IMAGE_NAME:$VERSION
	;;
	
	amd64)
		docker build ./ -t $IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=-amd64
	;;
	
	arm64v8)
		docker build ./ -t $IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --build-arg ARCH=-arm64v8
	;;
	
	arm32v7)
		docker build ./ -t $IMAGE_NAME:$VERSION-$SUBVERSION-arm32v7 \
			--file Dockerfile --build-arg ARCH=-arm32v7
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_alpine_php_fpm-*
		
		docker tag $IMAGE_NAME:$VERSION-$SUBVERSION-amd64 $IMAGE_NAME:$VERSION-amd64
		docker tag $IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 $IMAGE_NAME:$VERSION-arm64v8
		docker tag $IMAGE_NAME:$VERSION-$SUBVERSION-arm32v7 $IMAGE_NAME:$VERSION-arm32v7
		
		docker push $IMAGE_NAME:$VERSION-$SUBVERSION-amd64
		docker push $IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8
		docker push $IMAGE_NAME:$VERSION-$SUBVERSION-arm32v7
		
		docker push $IMAGE_NAME:$VERSION-amd64
		docker push $IMAGE_NAME:$VERSION-arm64v8
		docker push $IMAGE_NAME:$VERSION-arm32v7
		
		docker manifest create $IMAGE_NAME:$VERSION-$SUBVERSION \
			--amend $IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			--amend $IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 \
			--amend $IMAGE_NAME:$VERSION-$SUBVERSION-arm32v7
		docker manifest push $IMAGE_NAME:$VERSION-$SUBVERSION
		
		docker manifest create $IMAGE_NAME:$VERSION \
			--amend $IMAGE_NAME:$VERSION-amd64 \
			--amend $IMAGE_NAME:$VERSION-arm64v8 \
			--amend $IMAGE_NAME:$VERSION-arm32v7
		docker manifest push $IMAGE_NAME:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm64v8
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {amd64|arm64v8|arm32v7|manifest|all|test}"
		RETVAL=1

esac

exit $RETVAL

