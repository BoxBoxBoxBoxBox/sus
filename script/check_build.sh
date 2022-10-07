#!/usr/bin/env bash

msg() {
    echo -e "\e[1;32m$*\e[0m"
}

name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
device=$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)
a=$(grep 'FAILED:' $WORKDIR/rom/$name_rom/build.log -m1 || true)
b=$(grep '#### build completed successfully' $WORKDIR/rom/$name_rom/build.log -m1 || true)
compile_plox
if [ ! -e out/target/product/*/*2022*.zip ]; then # to bypass OOM
sed -i 's/-j$(nproc --all)/-j7/' /tmp/ci/build.sh
. $CIRRUS_WORKING_DIR/script/check_build.sh # run again to update values before starting compilation
compile_plox # simply re-run the build with less threads
fi
if [ ! -e out/target/product/*/*2022*.zip ]; then
sed -i 's/-j7/-j6/' /tmp/ci/build.sh
. $CIRRUS_WORKING_DIR/script/check_build.sh
compile_plox # just incase if -1 thread didnt help
fi
if [[ $a == *'FAILED:'* ]]
then
cd $WORKDIR/rom/$name_rom
echo ━━━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━━━
msg ⛔ .....Building Failed..... ⛔
echo ━━━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━━━
curl -F document=@build.log "https://api.telegram.org/bot${TG_TOKEN}/sendDocument" \
    -F chat_id="${TG_CHAT_ID}" \
    -F "disable_web_page_preview=true" \
    -F "parse_mode=html" \
    -F caption="⛔${device} Build $name_rom Error⛔

Mohon bersabar ini ujian, Kalao gk sabar ya banting aja HP nya awowok😅"
curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendSticker" -d sticker="CAACAgQAAx0EabRMmQACAvhjEpueqrNRuGJo5vCfzrjjnFH1gAACagoAAtMOGVGNqOvAKmWo-h4E" -d chat_id="${TG_CHAT_ID}"
fi
if [[ $b == *'#### build completed successfully'* ]]
  then
  echo ━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━
  msg ✅ Build is completed 100% ✅
  echo ━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━
else
  echo ━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━
  msg ❌ ...Build not completed... ❌
  echo ━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━
  echo Sed
fi
compile_plox
if [ ! -e out/target/product/*/*2022*.zip ]; then # to bypass OOM
sed -i 's/-j$(nproc --all)/-j7/' /tmp/ci/build.sh
. $CIRRUS_WORKING_DIR/script/check_build.sh # run again to update values before starting compilation
compile_plox # simply re-run the build with less threads
fi
if [ ! -e out/target/product/*/*2022*.zip ]; then
sed -i 's/-j7/-j6/' /tmp/ci/build.sh
. $CIRRUS_WORKING_DIR/script/check_build.sh
compile_plox # just incase if -1 thread didnt help
fi
