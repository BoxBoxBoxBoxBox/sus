#!/usr/bin/env bash

# Establish Git cookies
echo "${GIT_COOKIES}" > ~/git_cookies.sh
bash ~/git_cookies.sh

# Fixes
sudo touch /etc/mtab
sudo chmod 777 /etc/mtab

set -exv
name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
mkdir -p $WORKDIR/rom/$name_rom
cd $WORKDIR/rom/$name_rom
command=$(head $CIRRUS_WORKING_DIR/build.sh -n $(expr $(grep '# build rom' $CIRRUS_WORKING_DIR/build.sh -n | cut -f1 -d:) - 1))
only_sync=$(grep 'repo sync' $CIRRUS_WORKING_DIR/build.sh)
bash -c "$command" || true
rm -rf Sync-rom.log

# push to telegram
tg () {
curl -s "https://api.telegram.org/bot${TG_TOKEN}/sendmessage" --data "text=$1&chat_id=${TG_CHAT_ID}"
}

tg "$rom_name source sync completed!
Total Size: $(du -sh /tmp/rom | cut -d - -f 1 | cut -d / -f 1)
Time Took: $(($SECONDS / 60)) minute(s) and $(($SECONDS % 60)) second(s).
Status: $progress"