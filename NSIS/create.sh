#!/bin/sh

MAKENSIS="/cygdrive/c/Program Files (x86)/NSIS/makensis"
"$MAKENSIS" /DVERSION=10.0.0b /DVERSIONL=10.0.0.0 installer.nsi
