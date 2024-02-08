#!/usr/bin/env bash

PROJECT_PATH=$(pwd)

echo -e '\033[1m\033[32mBuilding BHInsta tweak for sideloading (as IPA)\033[0m'

make clean
rm -rf .theos
make

if [ -e ./packages/com.burbn.instagram.ipa ]; then

  echo -e '\033[1m\033[32mBuilding the IPA.\033[0m'
  azule -i "$PROJECT_PATH/packages/com.burbn.instagram.ipa" -o "$PROJECT_PATH/packages" -n BHInsta-sideloaded -r -f "$PROJECT_PATH/.theos/obj/debug/BHInsta.dylib" "$PROJECT_PATH/packages/Cephei.framework" "$PROJECT_PATH/packages/CepheiUI.framework" "$PROJECT_PATH/packages/CepheiPrefs.framework" "$PROJECT_PATH/modules/libflex/.theos/obj/debug/libbhFLEX.dylib"

  echo -e '\033[1m\033[32mDone, we hope you enjoy BHInsta!\033[0m'
else
  echo -e '\033[1m\033[0;31mpackages/com.burbn.instagram.ipa not found.\nPlease put a decrypted Instagram IPA in its path.\033[0m'
fi

# Install to device
cp -fr ./packages/BHInsta-sideloaded.ipa ~/Documents/Signing/BHInsta/ipas/UNSIGNED.ipa
cd ~/Documents/Signing
./sign.sh BHInsta
./deploy.sh BHInsta #true
