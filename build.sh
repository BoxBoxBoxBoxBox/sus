#sync rom
repo init -u https://github.com/PixelOS-Pixelish/manifest.git -b thirteen
git clone https://gitlab.com/R9Lab/Manifest.git --depth 1 -b PixelOS-13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch aosp_lava-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export TZ=Asia/Dhaka #put before last build command
make bacon -j$(nproc --all)
if [ ! -e out/target/product//*2022.zip ]; then # you don't have to run this you're not facing oom kill issue while build is about 98-98%
make bacon -j$(nproc --all) # re-run the build cuz there's still time left considering only few targets left
fi
#end
