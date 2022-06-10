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
    function GetStorageKey(Storage: TDataStorage): string; virtual;
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

function TCommonForm.GetStorageKey(Storage: TDataStorage): string;
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
  var storage := TDataStorage.Create(AFileName);
  try
    LoadFromStorage(storage);
  finally
    storage.Free;
  end;
end;

procedure TCommonForm.LoadFromStorage(Storage: TDataStorage);
begin
  Storage.PushStorageKey;
  try
    Storage.StorageKey := GetStorageKey(Storage);
    InternalLoadFromStorage(Storage);
    for var frame in ComponentsOf<TCommonFrame> do
      frame.LoadFromStorage(Storage);
  finally
    Storage.PopStorageKey;
  end;
end;

procedure TCommonForm.SaveToStorage;
begin
  SaveToStorage(SettingsFileName);
end;

procedure TCommonForm.SaveToStorage(const AFileName: string);
begin
  var storage := TDataStorage.Create(AFileName);
  try
    SaveToStorage(storage);
  finally
    storage.Free;
  end;
end;

procedure TCommonForm.SaveToStorage(Storage: TDataStorage);
begin
  Storage.PushStorageKey;
  try
    Storage.StorageKey := GetStorageKey(Storage);
    InternalSaveToStorage(Storage);
    for var frame in ComponentsOf<TCommonFrame> do
      frame.SaveToStorage(Storage);
  finally
    Storage.PopStorageKey;
  end;
end;

end.
