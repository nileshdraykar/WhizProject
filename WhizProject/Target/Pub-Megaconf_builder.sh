#!/bin/sh

#  builder.sh
#  AutobuildUsingReactNative
#
#  Created by Nilesh Dnyaneshwar Raykar on 09/07/20.
#  Copyright © 2020 Nilesh Dnyaneshwar Raykar. All rights reserved.
set -e
#IOS_CONFIGURATION="DEBUG"
IOS_CONFIGURATION="Distribution"
#IOS_CONFIGURATION="Release"
cur_dir=`pwd`
PROJECT_NAME="WhizProject"
#apple_id="shital@whizti.com"
#password="zxtw-jfuo-dgwe-plyg"
IOS_SCHEME="WhizProject"
AppStore_IOS_EXPORT_OPTIONS_PLIST="Pub-Megaconf_exportOption.plist"
Firebase_IOS_EXPORT_OPTIONS_PLIST="Pub-Megaconf_exportOption_Ad_Hoc.plist"
FIRBASE_APP_ID="1:704600838549:ios:863f8d46e37a2d35"
cd $cur_dir/../

pwd  # used for print current directory
git status
git remote update
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date No changes found on Remote"
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    git pull origin master
    xcrun agvtool next-version -all
    git commit -m "update build version"
    git push
    echo "Archiving the project"
    xcodebuild archive -project $cur_dir/../../${PROJECT_NAME}.xcodeproj -scheme $IOS_SCHEME -configuration $IOS_CONFIGURATION -derivedDataPath $cur_dir/../../../build -archivePath $cur_dir/../../../build/Products/${PROJECT_NAME}.xcarchive
    unset GEM_HOME
    unset GEM_PATH

    #echo "Export archive to create IPA file using $Firebase_IOS_EXPORT_OPTIONS_PLIST"
    #xcodebuild -exportArchive -archivePath $cur_dir/../../../build/Products/${PROJECT_NAME}.xcarchive -exportOptionsPlist $cur_dir/$Firebase_IOS_EXPORT_OPTIONS_PLIST -exportPath $cur_dir/../../../build/Products/IPA/$IOS_SCHEME/Firebase
    #
    #firebase appdistribution:distribute $cur_dir/../../../build/Products/IPA/$IOS_SCHEME/Firebase/$IOS_SCHEME.ipa  \
    #--app $FIRBASE_APP_ID  \
    #--release-notes-file $cur_dir/../Release-Notes.txt  --groups-file $cur_dir/../Testers-Group.txt


    echo "Export archive to create IPA file using $AppStore_IOS_EXPORT_OPTIONS_PLIST"
    xcodebuild -exportArchive -archivePath $cur_dir/../../../build/Products/${PROJECT_NAME}.xcarchive -exportOptionsPlist $cur_dir/$AppStore_IOS_EXPORT_OPTIONS_PLIST -exportPath $cur_dir/../../../build/Products/IPA/$IOS_SCHEME/App_Store

    #xcrun altool --upload-app -f $cur_dir/../../../build/Products/IPA/$IOS_SCHEME/App_Store/$IOS_SCHEME.ipa -u $apple_id -p $password —output-format xml

elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
    git commit -m "update build version"
    git push
else
    echo "Diverged"
fi
