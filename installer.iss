[Setup]
AppName=FocusTracker
AppVersion=1.0.0
DefaultDirName={pf}\FocusTracker
DefaultGroupName=FocusTracker
OutputDir=build
OutputBaseFilename=FocusTracker-Setup
Compression=lzma
SolidCompression=yes
SetupIconFile=windows/runner/resources/app_icon.ico
LicenseFile=LICENSE

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\FocusTracker"; Filename: "{app}\FocusTracker.exe"
Name: "{commondesktop}\FocusTracker"; Filename: "{app}\FocusTracker.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"