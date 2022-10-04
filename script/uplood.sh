#!/usr/bin/env bash

ccache_upload () {
	sleep 96m
	echo $(date +"%d-%m-%Y %T")
	time tar "-I zstd -1 -T2" -cf $1.tar.zst $1
	rclone copy --drive-chunk-size 256M --stats 1s $1.tar.zst NFS:$1/$NAME -P
}

ccache_stats () {
	export CCACHE_DIR=/tmp/ccache
	export CCACHE_EXEC=$(which ccache)
	ccache -s
}

cd /tmp
ccache_upload ccache
ccache_stats
