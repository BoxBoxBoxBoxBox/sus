#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/PixelExperience/manifest -b thirteen -g default,-mips,-darwin,-notdefault
git clone https://gitlab.com/R9Lab/Manifest.git --depth 1 -b 13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch aosp_lava-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export TZ=Asia/Dhaka #put before last build command
make recoveryimage
if [ ! -e out/target/product/*/recovery.img ]; then # you don't have to run this you're not facing oom kill issue while build is about 98-98%
make recoveryimage # re-run the build cuz there's still time left considering only few targets left
fi
#end
