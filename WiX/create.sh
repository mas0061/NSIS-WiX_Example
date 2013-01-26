#!/bin/sh

if [ $# -ne 1 ]; then
  exit
elif [ $1 = "x86" ]; then
  ARCH="x86"
  PROGRA_FILE="ProgramFilesFolder"
  SYS_FOLDER="SystemFolder"
elif [ $1 = "x64" ]; then
  ARCH="x64"
  PROGRA_FILE="ProgramFiles64Folder"
  SYS_FOLDER="System64Folder"
else
  exit
fi

VERSION="10.0.0"
CULTURE="ja-jp" # ja-jp or en-us

OUTPUT="setuppp-$VERSION-$ARCH.msi"
MAIN_WXS="installer.wxs"
FILE_WXS="installer_files.wxs"
UTIL_EXT="-ext WiXUtilExtension"

CANDLE_DOPT="-dTOOL_VERSION=$VERSION -dARCH=$ARCH -dPROGRA_FILE=$PROGRA_FILE -dSYS_FOLDER=$SYS_FOLDER"

heat dir files -dr HogeFiles -cg CG_NAME -gg -g1 -sfrag -srd -var "var.HogeDir" -out $FILE_WXS

candle -nologo $UTIL_EXT $CANDLE_DOPT $MAIN_WXS
candle -nologo -arch $ARCH -dHogeDir=files $FILE_WXS

light -nologo -cultures:$CULTURE -ext WixUIExtension $UTIL_EXT ${MAIN_WXS%wxs}wixobj ${FILE_WXS%wxs}wixobj -out $OUTPUT

rm -f *.wixobj $FILE_WXS ${OUTPUT%msi}wixpdb
