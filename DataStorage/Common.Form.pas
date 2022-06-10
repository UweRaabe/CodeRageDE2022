unit Common.Form;

interface

uses
  Vcl.Forms,
  Common.DataStorage;

type
  TCommonForm = class(TForm)
  private
    FSettingsFileName: string;
  protected
    function GetStorageKey: string; virtual;
    procedure InternalInitDefaults; virtual;
    procedure InternalLoadFromStorage(Storage: TDataStorage); virtual;
    procedure InternalSaveToStorage(Storage: TDataStorage); virtual;
    procedure LoadFromStorage(const AFileName: string); overload; virtual;
    procedure LoadFromStorage(Storage: TDataStorage); overload; virtual;
    procedure SaveToStorage(const AFileName: string); overload; virtual;
    procedure SaveToStorage(Storage: TDataStorage); overload; virtual;
  public
    procedure InitDefaults; virtual;
    procedure LoadFromStorage; overload; virtual;
    procedure SaveToStorage; overload; virtual;
    property SettingsFileName: string read FSettingsFileName write FSettingsFileName;
  end;
  
type
  TForm = TCommonForm;

implementation

uses
  System.IOUtils, System.IniFiles,
  Cmon.Utilities,
  Common.Frame;

function TCommonForm.GetStorageKey: string;
begin
  Result := Name;
end;

procedure TCommonForm.InitDefaults;
begin
  for var frame in ComponentsOf<TCommonFrame> do
    frame.InitDefaults;
  InternalInitDefaults;
end;

procedure TCommonForm.InternalInitDefaults;
begin
end;

procedure TCommonForm.InternalLoadFromStorage(Storage: TDataStorage);
begin
end;

procedure TCommonForm.InternalSaveToStorage(Storage: TDataStorage);
begin
end;

procedure TCommonForm.LoadFromStorage;
begin
  LoadFromStorage(SettingsFileName);
end;

procedure TCommonForm.LoadFromStorage(const AFileName: string);
begin
  var ini := TMemInifile.Create(AFileName);
  try
    LoadFromStorage(ini);
  finally
    ini.Free;
  end;
end;

procedure TCommonForm.LoadFromStorage(Storage: TDataStorage);
begin
  InternalLoadFromStorage(Storage);
  var section := GetStorageKey;
  for var frame in ComponentsOf<TCommonFrame> do
    frame.LoadFromStorage(Storage, section);
end;

procedure TCommonForm.SaveToStorage;
begin
  SaveToStorage(SettingsFileName);
end;

procedure TCommonForm.SaveToStorage(const AFileName: string);
begin
  var ini := TMemInifile.Create(AFileName);
  try
    SaveToStorage(ini);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TCommonForm.SaveToStorage(Storage: TDataStorage);
begin
  InternalSaveToStorage(Storage);
  var section := GetStorageKey;
  for var frame in ComponentsOf<TCommonFrame> do
    frame.SaveToStorage(Storage, section);
end;

end.
