unit uMyIniFile;

interface

uses
  System.Classes, System.Types, System.SysUtils, System.IniFiles,
  System.IOUtils, FMX.Dialogs, FMX.Memo, FMX.Types, FMX.Forms, System.UITypes,
  FMX.PlatForm;

type
  TMyIniFile = class(TObject)
  const

  private
    pathIni: String;
  public
    FormWidth, FormHeight, FormTop, FormLeft: Integer;
    strPassword: String;
    UsedComPort: Integer;
    isRemoteControl: Boolean;
    indexTimer: Integer;
    constructor Create;
    procedure LoadIniFile;
    procedure SaveIniFile;
  end;

var
  MyIniFile: TMyIniFile;

implementation

uses uMyFunctions;

constructor TMyIniFile.Create;
begin
  // C:\Users\UserName\Documents\exeName.ini
  // ExtractFileName(ParamStr(0)) µ¥¦P Application.Title

  pathIni := TPath.GetDocumentsPath + PathDelim + Application.title + '.ini';
  // ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');
  isDebug := false;
end;

procedure TMyIniFile.LoadIniFile;
var
  iniFile: TIniFile;
  i: Integer;
  str: String;
begin
  iniFile := TIniFile.Create(pathIni);
  try

    FormWidth := iniFile.ReadInteger('setting', 'FormWidth', 780);
    FormHeight := iniFile.ReadInteger('setting', 'FormHeight', 480);
    FormTop := iniFile.ReadInteger('setting', 'FormTop', 100);
    FormLeft := iniFile.ReadInteger('setting', 'FormLeft', 200);
    UsedComPort := iniFile.ReadInteger('setting', 'UsedComPort', 1);

    strPassword := iniFile.ReadString('setting', 'strPassword', '00000');
    isRemoteControl := iniFile.ReadBool('setting', 'isRemoteControl', false);

    indexTimer := iniFile.ReadInteger('setting', 'indexTimer', 0);
  finally
    iniFile.DisposeOf;
  end;
end;

procedure TMyIniFile.SaveIniFile;
var
  iniFile: TIniFile;
  i: Integer;
  str: String;
begin
  iniFile := TIniFile.Create(pathIni);
  try

    iniFile.WriteInteger('setting', 'FormWidth', FormWidth);
    iniFile.WriteInteger('setting', 'FormHeight', FormHeight);
    iniFile.WriteInteger('setting', 'FormTop', FormTop);
    iniFile.WriteInteger('setting', 'FormLeft', FormLeft);
    iniFile.WriteInteger('setting', 'UsedComPort', UsedComPort);

    iniFile.WriteString('setting', 'strPassword', strPassword);
    iniFile.WriteBool('setting', 'isRemoteControl', isRemoteControl);

    iniFile.WriteInteger('setting', 'indexTimer', indexTimer);
  finally
    iniFile.DisposeOf;
  end;
end;

end.
