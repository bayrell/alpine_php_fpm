#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=5.6
SUBVERSION=1
IMAGE_NAME="alpine_php_fpm"
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	test)
		docker build ./ -t bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-$TAG \
			--file Dockerfile --build-arg ARCH=amd64
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-$TAG \
			bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-$TAG bayrell/$IMAGE_NAME:$VERSION
	;;
	
	amd64)
		docker build ./ -t bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --progress=plain --build-arg ARCH=amd64
	;;
	
	arm64v8)
		docker build ./ -t bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --progress=plain --build-arg ARCH=arm64v8
	;;
	
	arm32v6)
		docker build ./ -t bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6 \
			--file Dockerfile --progress=plain --build-arg ARCH=arm32v6
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_alpine_php_fpm-*
		
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			bayrell/$IMAGE_NAME:$VERSION-amd64
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 \
			bayrell/$IMAGE_NAME:$VERSION-arm64v8
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6 \
			bayrell/$IMAGE_NAME:$VERSION-arm32v6
		
		docker push bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64
		docker push bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8
		docker push bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6
		
		docker push bayrell/$IMAGE_NAME:$VERSION-amd64
		docker push bayrell/$IMAGE_NAME:$VERSION-arm64v8
		docker push bayrell/$IMAGE_NAME:$VERSION-arm32v6
		
		docker manifest create bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION \
			--amend bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 \
			--amend bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6
		docker manifest push bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/$IMAGE_NAME:$VERSION \
			--amend bayrell/$IMAGE_NAME:$VERSION-amd64 \
			--amend bayrell/$IMAGE_NAME:$VERSION-arm64v8 \
			--amend bayrell/$IMAGE_NAME:$VERSION-arm32v6
		docker manifest push bayrell/$IMAGE_NAME:$VERSION
	;;
	
	upload-github)
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8
		
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6
		
		docker tag bayrell/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64
		
		docker push ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64
		docker push ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6
		docker push ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8
		
		docker manifest create --amend \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8
		docker manifest push --purge ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-$SUBVERSION
		
		docker tag bayrell/$IMAGE_NAME:$VERSION-arm64v8 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-arm64v8
		
		docker tag bayrell/$IMAGE_NAME:$VERSION-arm32v6 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-arm32v6
		
		docker tag bayrell/$IMAGE_NAME:$VERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-amd64
		
		docker push ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-amd64
		docker push ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-arm32v6
		docker push ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-arm64v8
		
		docker manifest create --amend \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-arm32v6 \
			ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION-arm64v8
		docker manifest push --purge ghcr.io/bayrell-os/$IMAGE_NAME:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm64v8
		$0 arm32v6
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {amd64|arm64v8|arm32v6|upload-github|manifest|all|test}"
		RETVAL=1

esac

exit $RETVAL

