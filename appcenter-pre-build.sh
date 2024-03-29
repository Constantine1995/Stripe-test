#!/usr/bin/env bash

# Example: Change bundle name of an iOS app for non-production
if [ "$APPCENTER_BRANCH" != "master" ];
then
plutil -replace CFBundleName -string "\$(PRODUCT_NAME) Beta" $APPCENTER_SOURCE_DIRECTORY/Stripe-test/Info.plist
fi

CUR_COCOAPODS_VER=`sed -n -e 's/^COCOAPODS: \([0-9.]*\)/\1/p' ios/Podfile.lock`
ENV_COCOAPODS_VER=`pod --version`

# check if not the same version, reinstall cocoapods version to current project's
if [ $CUR_COCOAPODS_VER != $ENV_COCOAPODS_VER ];
then
echo "Uninstalling all CocoaPods versions"
sudo gem uninstall cocoapods --all --executables
echo "Installing CocoaPods version $CUR_COCOAPODS_VER"
sudo gem install cocoapods -v $CUR_COCOAPODS_VER
else
echo "CocoaPods version is suitable for the project"
fi;
