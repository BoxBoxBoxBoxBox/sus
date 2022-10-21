rm -rf vendor/crDroidOTA
rm -rf packages/apps/Updater
git clone --depth 1 orkunergun/crDroidOTA -b 12.1 vendor/crDroidOTA
git clone --depth 1 orkunergun/crDroid-Updater -b 12.1 packages/apps/Updater
