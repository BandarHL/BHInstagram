#!/usr/bin/env bash

./build.sh

# Install to device
cp -fr ./packages/BHInsta-sideloaded.ipa ~/Documents/Signing/BHInsta/ipas/UNSIGNED.ipa
cd ~/Documents/Signing
./sign.sh BHInsta
./deploy.sh BHInsta #true