
#define AppVersion '4.16'
#define AppName    'Scid vs PC'
#define ActiveTclUrl 'http://www.activestate.com/activetcl/downloads'



[Setup]
AppName={# AppName}
AppVerName={# AppName} {# AppVersion}
AppVersion={# AppVersion}
AppPublisher=Steven Atkinson
AppPublisherURL=http://scidvspc.sourceforge.net
AppCopyright=Steven Atkinson (C) 2009 - 2015  Steven Atkinson (and others)
DefaultDirName={sd}\{# AppName}-{# AppVersion}
UsePreviousAppDir=no
DefaultGroupName={# AppName}
DisableStartupPrompt=yes
WindowShowCaption=yes
WindowVisible=no

LicenseFile=COPYING.txt

Compression=bzip/9
SourceDir=.
OutputDir=.
OutputBaseFilename={# AppName}-{# AppVersion}
ChangesAssociations=yes

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"
Name: associate_pgn; Description: "&Associate PGN files"; GroupDescription: "Other tasks:";
Name: associate_si4; Description: "&Associate SI4 files"; GroupDescription: "Other tasks:";


[Registry]
Root: "HKCU"; Subkey: "Software\Classes\.pgn"; Flags: uninsdeletevalue; Tasks: associate_pgn
Root: "HKCU"; Subkey: "Software\Classes\.pgn"; ValueType: string; ValueData: "scid"; Flags: uninsdeletevalue; Tasks: associate_pgn
Root: "HKCU"; Subkey: "Software\Classes\scid"; Flags: uninsdeletevalue; Tasks: associate_pgn
Root: "HKCU"; Subkey: "Software\Classes\scid\shell\open\command"; ValueType: string; ValueData: """{app}\bin\scid"" ""%1"""; Flags: uninsdeletevalue; Tasks: associate_pgn

Root: "HKCU"; Subkey: "Software\Classes\.si4"; Flags: uninsdeletevalue; Tasks: associate_si4
Root: "HKCU"; Subkey: "Software\Classes\.si4"; ValueType: string; ValueData: "scid"; Flags: uninsdeletevalue; Tasks: associate_si4
Root: "HKCU"; Subkey: "Software\Classes\scid"; Flags: uninsdeletevalue; Tasks: associate_si4
Root: "HKCU"; Subkey: "Software\Classes\scid\shell\open\command"; ValueType: string; ValueData: """{app}\bin\scid"" ""%1"""; Flags: uninsdeletevalue; Tasks: associate_si4

[Files]
Source: "bin\*";  DestDir: "{app}\bin"; CopyMode: normal; Flags: recursesubdirs
Source: "lib\*"; DestDir: "{app}\lib";  CopyMode: normal; Flags: recursesubdirs
Source: "doc\*"; DestDir: "{app}\doc";  CopyMode: normal; Flags: recursesubdirs
Source: "COPYING.txt"; DestDir: "{app}";  CopyMode: normal; Flags: recursesubdirs
Source: "README.txt"; DestDir: "{app}";  CopyMode: normal; Flags: recursesubdirs
Source: "README.html"; DestDir: "{app}";  CopyMode: normal; Flags: recursesubdirs
Source: "images\*"; DestDir: "{app}\images";  CopyMode: normal; Flags: recursesubdirs

[Icons]
Name: "{group}\{# AppName}"; Filename: "{app}\bin\scid.exe"; Comment: "{# AppName}!"; WorkingDir: {app}\bin
Name: "{group}\Uninstall {# AppName}"; Filename: "{uninstallexe}";
Name: "{userdesktop}\{# AppName}"; Filename: "{app}\bin\scid.exe"; Tasks: desktopicon; Comment: "Desktop {# AppName}!"; WorkingDir: {app}\bin

[Run]
Filename: "{app}\bin\scid.exe"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent


[Code]
procedure URLLabelOnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', '{# ActiveTclUrl}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

var
  tclPage: TOutputMsgWizardPage;

procedure InitializeWizard();
begin

end;










