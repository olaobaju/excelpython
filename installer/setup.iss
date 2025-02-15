; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "ExcelPython"
#define MyAppVersion "2.0.7"
#define MyAppPublisher "ericremoreynolds"
#define MyAppURL "https://github.com/ericremoreynolds/excelpython"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{729BFC46-B43F-4BA7-9DD2-8D42F116EE9C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
LicenseFile=D:\github\excelpython\LICENSE
OutputDir=D:\github\excelpython\installer
OutputBaseFilename=excelpython-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
DefaultDirName={code:DefAppFolder}
UninstallFilesDir={pf}\ExcelPython

DirExistsWarning=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Dirs]
Name: "{app}\xlpython"

[Files]
Source: "..\addin\xlpython.xlam"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\addin\xlpython\*"; DestDir: "{app}\xlpython"; Flags: ignoreversion recursesubdirs createallsubdirs
; Source: IssProc.dll; DestDir: "{tmp}"; Flags: dontcopy
; Source: IssProc.dll; DestDir: "{pf}\ExcelPython"

[Code]
Function DefAppFolder(Param: String): String;
Begin
  If DirExists(ExpandConstant('{%APPDATA}\Roaming\Microsoft\Excel\XLSTART')) Then Begin
    Result := ExpandConstant('{%APPDATA}\Roaming\Microsoft\Excel\XLSTART');
  End Else Begin
    Result := ExpandConstant('{%APPDATA}\Microsoft\Excel\XLSTART');
  End;
End;

// Windows CreateFile function
function CreateFile(
    lpFileName             : String;
    dwDesiredAccess        : Cardinal;
    dwShareMode            : Cardinal;
    lpSecurityAttributes   : Cardinal;
    dwCreationDisposition  : Cardinal;
    dwFlagsAndAttributes   : Cardinal;
    hTemplateFile          : Integer
): THandle;
#ifdef UNICODE
  external 'CreateFileW@kernel32.dll stdcall';
#else
  external 'CreateFileA@kernel32.dll stdcall';
#endif

// Windows CloseHandle function
function CloseHandle(hHandle: THandle): BOOL;
external 'CloseHandle@kernel32.dll stdcall';

Const
  GENERIC_WRITE = $40000000;
  { FILE_ATTRIBUTE_NORMAL = $80; }
  OPEN_EXISTING = 3;
  INVALID_HANDLE_VALUE = -1;

// Function to check if file can be deleted
Function CanDelete(FileName: String): Boolean;
Var
  FileHandle: THandle;
Begin
  Result := False;
  FileHandle := CreateFile(FileName, GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (FileHandle <> INVALID_HANDLE_VALUE);
  If Result Then CloseHandle(FileHandle);
End;

// Ensure that the add-in can be deleted
function InitializeUninstall(): Boolean;
begin
  Result := false;
  If CanDelete(ExpandConstant('{app}\xlpython.xlam')) Then Begin
    Result := true;
  End Else Begin
    MsgBox('ExcelPython appears to be in use - please make sure you close all instances of Excel before uninstalling.', mbError, MB_OK)
    Result := false;
  End;
end;

