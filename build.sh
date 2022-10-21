#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/crdroidandroid/android.git -b 12.1 -g default,-mips,-darwin,-notdefault
git clone https://github.com/crdroid-lava/Manifest.git --depth 1 -b 12.1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch lineage_lava-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export TZ=Asia/Dhaka #put before last build command
make bacon -j$(nproc --all)
if [ ! -e out/target/product//*2022.zip ]; then # you don't have to run this you're not facing oom kill issue while build is about 98-98%
make bacon -j$(nproc --all) # re-run the build cuz there's still time left considering only few targets left
fi
#end
