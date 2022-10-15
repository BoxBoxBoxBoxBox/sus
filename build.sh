#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/CherishOS/android_manifest.git -b tiramisu -g default,-mips,-darwin,-notdefault
git clone https://gitlab.com/R9Lab/Manifest.git --depth 1 -b CherishOS-13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch cherish_lava-userdebug
#export WITH_GMS=true
#export TARGET_USES_MINI_GAPPS=true
export CHERISH_VANILLA=true
export SELINUX_IGNORE_NEVERALLOWS=true
export TZ=Asia/Dhaka #put before last build command
compile_plox () {
make bacon -j$(nproc --all)
}
if [ ! -e out/target/product/*/*2022*.zip ]; then # to bypass OOM kill
sed -i 's/-j$(nproc --all)/-j7/' /tmp/script/building.sh
. /tmp/script/building.sh # run again to update values before starting compilation
compile_plox # simply re-run the build with less threads
fi
if [ ! -e out/target/product/*/*2022*.zip ]; then
sed -i 's/-j7/-j6/' /tmp/script/building.sh
. /tmp/script/building.sh
compile_plox # just incase if -1 thread didnt help
#end