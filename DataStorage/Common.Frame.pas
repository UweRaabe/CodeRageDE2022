unit Common.Frame;

interface

uses
  Vcl.Forms,
  Common.DataStorage;

type
  TCommonFrame = class(TFrame)
  protected
    function GetStorageKey(const ParentSection: string = ''): string; virtual;
    procedure InternalInitDefaults; virtual;
    procedure InternalLoadFromStorage(Storage: TDataStorage; const ParentSection: string = ''); virtual;
    procedure InternalSaveToStorage(Storage: TDataStorage; const ParentSection: string = ''); virtual;
  public
    procedure InitDefaults; virtual;
    procedure LoadFromStorage(Storage: TDataStorage; const ParentSection: string = ''); virtual;
    procedure SaveToStorage(Storage: TDataStorage; const ParentSection: string = ''); virtual;
  end;
  
type
  TFrame = TCommonFrame;

implementation

uses
  Cmon.Utilities;

function TCommonFrame.GetStorageKey(const ParentSection: string = ''): string;
begin
  Result := Name;
  if ParentSection > '' then
    Result := ParentSection + '\' + Result;
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

procedure TCommonFrame.InternalLoadFromStorage(Storage: TDataStorage; const ParentSection: string = '');
begin
end;

procedure TCommonFrame.InternalSaveToStorage(Storage: TDataStorage; const ParentSection: string = '');
begin
end;

procedure TCommonFrame.LoadFromStorage(Storage: TDataStorage; const ParentSection: string);
begin
  InternalLoadFromStorage(Storage, ParentSection);
  var section := GetStorageKey(ParentSection);
  for var frame in ComponentsOf<TCommonFrame> do
    frame.LoadFromStorage(Storage, section);
end;

procedure TCommonFrame.SaveToStorage(Storage: TDataStorage; const ParentSection: string);
begin
  InternalSaveToStorage(Storage, ParentSection);
  var section := GetStorageKey(ParentSection);
  for var frame in ComponentsOf<TCommonFrame> do
    frame.SaveToStorage(Storage, section);
end;

end.
