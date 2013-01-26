; Sample Installer by NSIS

!include MUI2.nsh
!include x64.nsh
!include LogicLib.nsh

!define NAME "Hoge Toolbox"
!define PACKAGE "${NAME} ${VERSION}"
!define APPDIR "files"
!define HOGE_CORP "Hoge Corporation"
!define HOGE_URL "http://www.hoge.com/"

!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall"

Name "${PACKAGE}"
OutFile "setuppp-${VERSION}.exe"

InstallDir "$PROGRAMFILES64\${PACKAGE}"
InstallDirRegKey HKLM "SOFTWARE\${PACKAGE}" ""

RequestExecutionLevel admin
ShowInstDetails show
ShowUninstDetails show
VIProductVersion ${VERSIONL}
VIAddVersionKey "ProductName" "${PACKAGE}"
VIAddVersionKey "CompanyName" "${SCSK_CORP}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "FileDescription" "${PACKAGE}"
VIAddVersionKey "LegalCopyright" "${SCSK_CORP}"

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
 
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-r.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall-r.bmp"
 
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE $(license)
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Japanese"

LicenseLangString license ${LANG_JAPANESE} "ja.rtf"
LicenseLangString license ${LANG_ENGLISH} "en.rtf"

Section
  SectionIn RO

  SetOutPath $INSTDIR
  File /r "${APPDIR}\api"
  File "${APPDIR}\test.txt"

  ${If} ${RunningX64}
    File /r "${APPDIR}\bin64"
    Rename "$INSTDIR\bin64" "$INSTDIR\bin"
  ${Else}
    File /r "${APPDIR}\bin86"
    Rename "$INSTDIR\bin86" "$INSTDIR\bin"
  ${EndIf}

  SetShellVarContext all

  CreateDirectory "$SMPROGRAMS\${PACKAGE}"
  CreateShortCut "$SMPROGRAMS\${PACKAGE}\hoge.lnk" "$INSTDIR\bin\hoge.exe"
  CreateShortCut "$SMPROGRAMS\${PACKAGE}\Uninstall.lnk" "$INSTDIR\uninstall.exe"

  CreateShortCut "$DESKTOP\${NAME}.lnk" "$INSTDIR\bin\hoge.exe" ""

  WriteRegStr HKLM "SOFTWARE\${PACKAGE}" "" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTALL_KEY}\${PACKAGE}" "DisplayName" "${PACKAGE} (remove only)"
  WriteRegStr HKLM "${UNINSTALL_KEY}\${PACKAGE}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKLM "${UNINSTALL_KEY}\${PACKAGE}" "Publisher" "${HOGE_CORP}"
  WriteRegStr HKLM "${UNINSTALL_KEY}\${PACKAGE}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "${UNINSTALL_KEY}\${PACKAGE}" "HelpLink" "${HOGE_URL}"

  WriteRegStr HKCR ".hoge" "" "Hoge.File"
  WriteRegStr HKCR "Hoge.File" "" "Hoge file"
  WriteRegStr HKCR "Hoge.File\DefaultIcon" "" "$INSTDIR\bin\hoge.exe,1"
  
  WriteUninstaller "uninstall.exe"
SectionEnd

Section Uninstall
  DeleteRegKey HKLM "${UNINSTALL_KEY}\${PACKAGE}"
  DeleteRegKey HKLM "SOFTWARE\${PACKAGE}"
  DeleteRegKey HKCR ".hoge"
  DeleteRegKey HKCR "Hoge.File"

  Delete "$DESKTOP\${NAME}.lnk"
  Delete "C:\Users\Public\Desktop\${NAME}.lnk"
  RMDir /r "$INSTDIR"
  
  SetShellVarContext all
  RMDir /r "$SMPROGRAMS\${PACKAGE}"
SectionEnd

Function .onInit
  ; for debug
  ; English
;  StrCpy $LANGUAGE 1033
  ; Japanese
;  StrCpy $LANGUAGE 1041
FunctionEnd
