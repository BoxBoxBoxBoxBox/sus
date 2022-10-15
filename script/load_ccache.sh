#!/usr/bin/env bash

cd $WORKDIR
mkdir -p ~/.config/rclone
echo "$RCLONECONFIG_DRIVE" > ~/.config/rclone/rclone.conf
name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
rclone copy --drive-chunk-size 256M --stats 1s NFS:ccache/$name_rom/ccache.tar.gz $WORKDIR -P
tar xzf ccache.tar.gz
tg "$rom_name ccache downloaded successfully!
Total Size: $(ls -sh ${PWD}/ccache.tar.gz | cut -d - -f 1 | cut -d / -f 1)
Time Took: $(($SECONDS / 60)) minute(s) and $(($SECONDS % 60)) second(s).
rm -rf ccache.tar.gz
