unit Common.DataStorage;

interface

uses
  System.IniFiles, System.Generics.Collections;

type
  TDataStorage = class
  const
    cKeySeparator: string = '\';
    cBool: array[Boolean] of Integer = (0, 1);
  private type
    TStorageKeyStack = TStack<string>;
  private
    FStorageKey: string;
    FStorageKeyStack: TStorageKeyStack;
    FStorageTarget: TCustomIniFile;
  strict protected
    function InternalReadString(const Ident, Default: string): string;
    procedure InternalWriteString(const Ident, Value: string);
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    function MakeStorageSubKey(const ASubKey: string): string;
    procedure PopStorageKey;
    procedure PushStorageKey; overload;
    procedure PushStorageKey(const NewKey: string); overload;
    function ReadBoolean(const Ident: string; const Default: Boolean): Boolean;
    function ReadInteger(const Ident: string; const Default: Integer): Integer;
    function ReadString(const Ident, Default: string): string;
    procedure WriteBoolean(const Ident: string; const Value: Boolean);
    procedure WriteInteger(const Ident: string; const Value: Integer);
    procedure WriteString(const Ident: string; const Value: string);
    property StorageKey: string read FStorageKey write FStorageKey;
  end;

implementation

uses
  System.SysUtils;

constructor TDataStorage.Create(const AFileName: string);
begin
  inherited Create;
  FStorageKeyStack := TStorageKeyStack.Create();
  FStorageTarget := TMemIniFile.Create(AFileName);
  TMemIniFile(FStorageTarget).AutoSave := True;
end;

destructor TDataStorage.Destroy;
begin
  FStorageTarget.Free;
  FStorageKeyStack.Free;
  inherited Destroy;
end;

function TDataStorage.InternalReadString(const Ident, Default: string): string;
begin
  Result := Default;
  if Assigned(FStorageTarget) then
    Result := FStorageTarget.ReadString(StorageKey, Ident, Default);
end;

procedure TDataStorage.InternalWriteString(const Ident, Value: string);
begin
  if Assigned(FStorageTarget) then
    FStorageTarget.WriteString(StorageKey, Ident, Value);
end;

function TDataStorage.MakeStorageSubKey(const ASubKey: string): string;
begin
  Result := StorageKey + cKeySeparator + ASubKey;
end;

procedure TDataStorage.PopStorageKey;
begin
  StorageKey := FStorageKeyStack.Pop;
end;

procedure TDataStorage.PushStorageKey;
begin
  FStorageKeyStack.Push(StorageKey);
end;

procedure TDataStorage.PushStorageKey(const NewKey: string);
begin
  PushStorageKey;
  StorageKey := NewKey;
end;

function TDataStorage.ReadBoolean(const Ident: string; const Default: Boolean): Boolean;
begin
  Result := (ReadInteger(Ident, cBool[Default]) = cBool[true]);
end;

function TDataStorage.ReadInteger(const Ident: string; const Default: Integer): Integer;
var
  S: string;
begin
  S := ReadString(Ident, '');
  if (S.Length > 2) and (S.StartsWith('0x',true)) then begin
    S := '$' + S.Substring(2);
  end;
  Result := StrToIntDef(S, Default);
end;

function TDataStorage.ReadString(const Ident, Default: string): string;
begin
  Result := InternalReadString(Ident, Default);
end;

procedure TDataStorage.WriteBoolean(const Ident: string; const Value: Boolean);
begin
  WriteInteger(Ident, cBool[Value]);
end;

procedure TDataStorage.WriteInteger(const Ident: string; const Value: Integer);
begin
  WriteString(Ident, IntToStr(Value));
end;

procedure TDataStorage.WriteString(const Ident: string; const Value: string);
begin
  InternalWriteString(Ident, Value);
end;

end.
