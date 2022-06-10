unit Common.Frame;

interface

uses
  Vcl.Forms,
  Common.DataStorage;

type
  TCommonFrame = class(TFrame)
  protected
    function GetStorageKey(Storage: TDataStorage): string; virtual;
    procedure InternalInitDefaults; virtual;
    procedure InternalLoadFromStorage(Storage: TDataStorage); virtual;
    procedure InternalSaveToStorage(Storage: TDataStorage); virtual;
  public
    procedure InitDefaults; virtual;
    procedure LoadFromStorage(Storage: TDataStorage); virtual;
    procedure SaveToStorage(Storage: TDataStorage); virtual;
  end;
  
type
  TFrame = TCommonFrame;

implementation

uses
  Cmon.Utilities;

function TCommonFrame.GetStorageKey(Storage: TDataStorage): string;
begin
  Result := Storage.MakeStorageSubKey(Name);
end;

procedure TCommonFrame.InitDefaults;
begin
  for var frame in ComponentsOf<TCommonFrame> do
    frame.InitDefaults;
  InternalInitDefaults;
end;

procedure TCommonFrame.InternalInitDefaults;
begin
end;

procedure TCommonFrame.InternalLoadFromStorage(Storage: TDataStorage);
begin
end;

procedure TCommonFrame.InternalSaveToStorage(Storage: TDataStorage);
begin
end;

procedure TCommonFrame.LoadFromStorage(Storage: TDataStorage);
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

procedure TCommonFrame.SaveToStorage(Storage: TDataStorage);
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
