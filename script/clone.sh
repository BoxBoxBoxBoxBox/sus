#!/usr/bin/env bash

rm -rf frameworks/base
git clone --depth 1 https://github.com/orkunergun/frameworks_base -b tm frameworks/base
rm -rf packages/apps/Settings
git clone --depth 1 https://github.com/orkunergun/packages_apps_Settings -b tm packages/apps/Settings
rm -rf vendor/proton
git clone --depth 1 https://github.com/orkunergun/vendor_proton -b tm vendor/proton
rm -rf packages/apps/Updater
git clone --depth 1 https://github.com/orkunergun/ProtonPlusUpdater -b tm packages/apps/Updater
