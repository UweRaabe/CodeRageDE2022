unit Main.Form;

interface

uses
  System.Classes, System.IniFiles,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.Dialogs,
  Cmon.DataStorage,
  Common.Frame, Common.Form,
  Main.Frame;

type
{$SCOPEDENUMS ON}
  TMyEnum = (none, enum1, enum2, enum3, enum4);
{$SCOPEDENUMS OFF}

type
  TDemoMainForm = class(TForm)
    SomeTextEdit: TLabeledEdit;
    SomeIndexSelector: TRadioGroup;
    DemoFrame1: TDemoFrame;
    DemoFrame2: TDemoFrame;
    TitleLabel: TLabel;
    SomeEnumSelector: TRadioGroup;
    SomeBooleanCheck: TCheckBox;
    SaveSettingsButton: TButton;
    LoadSettingsButton: TButton;
    LoadSettingsDialog: TFileOpenDialog;
    SaveSettingsDialog: TFileSaveDialog;
    RestoreDefaultsButton: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadSettingsButtonClick(Sender: TObject);
    procedure RestoreDefaultsButtonClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
  strict private
  class var
    FSettingsFileExtension: string;
    FSettingsFileName: string;
  private
    class function GetSettingsFileName: string; static;
    function GetSomeBoolean: Boolean;
    function GetSomeEnum: TMyEnum;
    function GetSomeIndex: Integer;
    function GetSomeText: string;
    procedure PrepareFileDialog(ADialog: TCustomFileDialog);
    procedure SetSomeBoolean(const Value: Boolean);
    procedure SetSomeEnum(const Value: TMyEnum);
    procedure SetSomeIndex(const Value: Integer);
    procedure SetSomeText(const Value: string);
  protected
    procedure InternalInitDefaults(Storage: TDataStorage); override;
    procedure InternalLoadFromStorage(Storage: TDataStorage); overload; override;
    procedure InternalSaveToStorage(Storage: TDataStorage); overload; override;
    procedure LoadSettings;
    procedure RestoreDefaults;
    procedure SaveSettings;
  public
    procedure UpdateTitle;
    class property SettingsFileExtension: string read FSettingsFileExtension write FSettingsFileExtension;
    class property SettingsFileName: string read GetSettingsFileName write FSettingsFileName;
    property SomeBoolean: Boolean read GetSomeBoolean write SetSomeBoolean;
    property SomeEnum: TMyEnum read GetSomeEnum write SetSomeEnum;
    property SomeIndex: Integer read GetSomeIndex write SetSomeIndex;
    property SomeText: string read GetSomeText write SetSomeText;
  end;

var
  DemoMainForm: TDemoMainForm;

implementation

uses
  System.SysUtils, System.IOUtils, System.Rtti,
  Vcl.Consts,
  Cmon.Utilities;

{$R *.dfm}

const
  cSomeBoolean = 'SomeBoolean';
  cSomeEnum = 'SomeEnum';
  cSomeIndex = 'SomeIndex';
  cSomeText = 'SomeText';

resourcestring
  SLoadSettings = 'Load settings';
  SSaveSettings = 'Save settings';

type
  TMyEnumHelper = record helper for TMyEnum
  private
    function GetAsIndex: Integer;
    function GetAsString: string;
    procedure SetAsIndex(const Value: Integer);
    procedure SetAsString(const Value: string);
  public
    class function FromIndex(Value: Integer): TMyEnum; static;
    class function FromString(const Value: string): TMyEnum; static;
    class procedure ListNames(Target: TStrings); static;
    property AsIndex: Integer read GetAsIndex write SetAsIndex;
    property AsString: string read GetAsString write SetAsString;
  end;

function TMyEnumHelper.GetAsIndex: Integer;
begin
  Result := Ord(Self);
end;

function TMyEnumHelper.GetAsString: string;
begin
  Result := TRttiEnumerationType.GetName(Self);
end;

procedure TMyEnumHelper.SetAsIndex(const Value: Integer);
begin
  Self := TMyEnum(Value);
end;

procedure TMyEnumHelper.SetAsString(const Value: string);
begin
  Self := TRttiEnumerationType.GetValue<TMyEnum>(Value);
end;

class function TMyEnumHelper.FromIndex(Value: Integer): TMyEnum;
begin
  Result.AsIndex := Value;
end;

class function TMyEnumHelper.FromString(const Value: string): TMyEnum;
begin
  Result.AsString := Value;
end;

class procedure TMyEnumHelper.ListNames(Target: TStrings);
var
  enum: TMyEnum;
begin
  Target.BeginUpdate;
  try
    Target.Clear;
    for enum := Low(enum) to High(enum) do
      Target.Add(enum.AsString);
  finally
    Target.EndUpdate;
  end;
end;

procedure TDemoMainForm.FormDestroy(Sender: TObject);
begin
  SaveToStorage;
end;

procedure TDemoMainForm.FormCreate(Sender: TObject);
begin
  { set position suitable for screen recording }
  Left := Screen.Monitors[1].Left + 100;
  Top := Screen.Monitors[1].Top + 100;
  Position := poDesigned;

  TMyEnum.ListNames(SomeEnumSelector.Items);
  inherited;
  LoadSettingsDialog.Title := SLoadSettings;
  SaveSettingsDialog.Title := SSaveSettings;
  PrepareFileDialog(LoadSettingsDialog);
  PrepareFileDialog(SaveSettingsDialog);
  InitDefaults;
  LoadFromStorage;
  UpdateTitle;
  for var frame in ComponentsOf<TDemoFrame> do
    frame.UpdateTitle;
end;

class function TDemoMainForm.GetSettingsFileName: string;
begin
  if FSettingsFileName.IsEmpty then
    Result := TPath.ChangeExtension(TUtilities.GetExeName, SettingsFileExtension)
  else if TDataStorage.IsSupportedTargetExtension(TPath.GetExtension(FSettingsFileName)) then
    Result := FSettingsFileName
  else
    Result := TPath.ChangeExtension(FSettingsFileName, SettingsFileExtension);
end;

procedure TDemoMainForm.LoadSettingsButtonClick(Sender: TObject);
begin
  inherited;
  LoadSettings;
end;

procedure TDemoMainForm.RestoreDefaultsButtonClick(Sender: TObject);
begin
  inherited;
  RestoreDefaults;
end;

procedure TDemoMainForm.SaveSettingsButtonClick(Sender: TObject);
begin
  inherited;
  SaveSettings;
end;

function TDemoMainForm.GetSomeBoolean: Boolean;
begin
  Result := SomeBooleanCheck.Checked;
end;

function TDemoMainForm.GetSomeEnum: TMyEnum;
begin
  Result.AsIndex := SomeEnumSelector.ItemIndex;
end;

function TDemoMainForm.GetSomeIndex: Integer;
begin
  Result := SomeIndexSelector.ItemIndex;
end;

function TDemoMainForm.GetSomeText: string;
begin
  Result := SomeTextEdit.Text;
end;

procedure TDemoMainForm.PrepareFileDialog(ADialog: TCustomFileDialog);
begin
  var defaultExt := SettingsFileExtension;
  var targets := TStorageTargetDescriptorList.Create;
  try
    TDataStorage.ListStorageTargets(targets);
    ADialog.FileTypes.Clear;
    for var target in targets do begin
      var fileType := ADialog.FileTypes.Add;
      fileType.DisplayName := Format('%s (*%s)', [target.Description, target.FileExtension]);
      fileType.FileMask := Format('*%s', [target.FileExtension]);
      if SameText(defaultExt, target.FileExtension) then
        ADialog.FileTypeIndex := ADialog.FileTypes.Count;
    end;

    var arr := SDefaultFilter.Split(['|']);
    var fileType := ADialog.FileTypes.Add;
    fileType.DisplayName := arr[0];
    fileType.FileMask := arr[1];
  finally
    targets.Free;
  end;
  ADialog.DefaultExtension := defaultExt.Substring(1);
  ADialog.FileName := SettingsFileName;
end;

procedure TDemoMainForm.SetSomeBoolean(const Value: Boolean);
begin
  SomeBooleanCheck.Checked := Value;
end;

procedure TDemoMainForm.SetSomeEnum(const Value: TMyEnum);
begin
  SomeEnumSelector.ItemIndex := Value.AsIndex;
end;

procedure TDemoMainForm.SetSomeIndex(const Value: Integer);
begin
  SomeIndexSelector.ItemIndex := Value;
end;

procedure TDemoMainForm.SetSomeText(const Value: string);
begin
  SomeTextEdit.Text := Value;
end;

procedure TDemoMainForm.InternalInitDefaults(Storage: TDataStorage);
begin
  inherited;
  SomeBoolean := True;
  SomeEnum := TMyEnum.None;
  SomeIndex := 1;
  SomeText := 'Hello World';
end;

procedure TDemoMainForm.InternalLoadFromStorage(Storage: TDataStorage);
begin
  inherited;
  SomeBoolean := Storage.ReadBoolean(cSomeBoolean, True);
  SomeEnum := TMyEnum.FromString(Storage.ReadString(cSomeEnum, TMyEnum.None.AsString));
  SomeIndex := Storage.ReadInteger(cSomeIndex, 1);
  SomeText := Storage.ReadString(cSomeText, 'Hello World');
end;

procedure TDemoMainForm.InternalSaveToStorage(Storage: TDataStorage);
begin
  inherited;
  Storage.WriteBoolean(cSomeBoolean, SomeBoolean);
  Storage.WriteString(cSomeEnum, SomeEnum.AsString);
  Storage.WriteInteger(cSomeIndex, SomeIndex);
  Storage.WriteString(cSomeText, SomeText);
end;

procedure TDemoMainForm.LoadSettings;
begin
  if LoadSettingsDialog.Execute then
    LoadFromStorage(LoadSettingsDialog.FileName);
end;

procedure TDemoMainForm.RestoreDefaults;
begin
  InitDefaults;
end;

procedure TDemoMainForm.SaveSettings;
begin
  if SaveSettingsDialog.Execute then
    SaveToStorage(SaveSettingsDialog.FileName);
end;

procedure TDemoMainForm.UpdateTitle;
begin
  TitleLabel.Caption := Name;
end;

end.
