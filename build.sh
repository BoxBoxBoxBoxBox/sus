# Eşitle
repo init --depth=1 --no-repo-verify -u https://github.com/ProjectBlaze/manifest.git -b 13 -g default,-mips,-darwin,-notdefault
git clone https://gitlab.com/R9Lab/Manifest.git --depth 1 -b ProjectBlaze-13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# Yapı
source build/envsetup.sh
lunch blaze_lava-userdebug
export WITH_GAPPS=false
export SELINUX_IGNORE_NEVERALLOWS=true
export TZ=Asia/Dhaka
mka bacon
