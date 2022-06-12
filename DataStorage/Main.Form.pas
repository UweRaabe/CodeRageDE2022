unit Main.Form;

interface

uses
  System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.Dialogs,
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
  private
    FSettingsFileName: string;
    procedure PrepareFileDialog(ADialog: TCustomFileDialog);
  protected
    procedure InitDefaults;
    procedure LoadFromStorage(const AFileName: string);
    procedure LoadSettings;
    procedure RestoreDefaults;
    procedure SaveSettings;
    procedure SaveToStorage(const AFileName: string);
  public
    procedure UpdateTitle;
    property SettingsFileName: string read FSettingsFileName write FSettingsFileName;
  end;

var
  DemoMainForm: TDemoMainForm;

implementation

uses
  System.SysUtils, System.IOUtils, System.Rtti, System.IniFiles,
  Vcl.Consts;

resourcestring
  SLoadSettings = 'Load settings';
  SSaveSettings = 'Save settings';

{$R *.dfm}

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
  SaveToStorage(SettingsFileName);
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
  SettingsFileName := TPath.ChangeExtension(Application.ExeName, '.ini');
  InitDefaults;
  LoadFromStorage(SettingsFileName);
  UpdateTitle;
  DemoFrame1.UpdateTitle;
  DemoFrame2.UpdateTitle;
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

procedure TDemoMainForm.PrepareFileDialog(ADialog: TCustomFileDialog);
begin
  var defaultExt := '.ini';
  ADialog.FileTypes.Clear;

  var fileType := ADialog.FileTypes.Add;
  fileType.DisplayName := Format('%s (*%s)', ['INI files', defaultExt]);
  fileType.FileMask := Format('*%s', [defaultExt]);
  ADialog.FileTypeIndex := ADialog.FileTypes.Count;

  var arr := SDefaultFilter.Split(['|']);
  fileType := ADialog.FileTypes.Add;
  fileType.DisplayName := arr[0];
  fileType.FileMask := arr[1];

  ADialog.DefaultExtension := defaultExt.Substring(1);
  ADialog.FileName := SettingsFileName;
end;

procedure TDemoMainForm.InitDefaults;
begin
  SomeBooleanCheck.Checked := True;
  SomeEnumSelector.ItemIndex := TMyEnum.None.AsIndex;
  SomeIndexSelector.ItemIndex := 1;
  SomeTextEdit.Text := 'Hello World';
  DemoFrame1.SomeIndexSelector.ItemIndex := -1;
  DemoFrame1.SomeTextEdit.Text := '';
  DemoFrame2.SomeIndexSelector.ItemIndex := -1;
  DemoFrame2.SomeTextEdit.Text := '';
end;

procedure TDemoMainForm.LoadFromStorage(const AFileName: string);
begin
  var ini := TMemInifile.Create(AFileName);
  try
    var section := Name;
    SomeBooleanCheck.Checked := ini.ReadBool(section, 'SomeBoolean', True);
    SomeEnumSelector.ItemIndex := TMyEnum.FromString(ini.ReadString(section, 'SomeEnum', TMyEnum.None.AsString)).AsIndex;
    SomeIndexSelector.ItemIndex := ini.ReadInteger(section, 'SomeIndex', 1);
    SomeTextEdit.Text := ini.ReadString(section, 'SomeText', 'Hello World');
    section := Name + '\' + DemoFrame1.Name;
    DemoFrame1.SomeIndexSelector.ItemIndex := ini.ReadInteger(section, 'SomeIndex', -1);
    DemoFrame1.SomeTextEdit.Text := ini.ReadString(section, 'SomeText', '');
    section := Name + '\' + DemoFrame2.Name;
    DemoFrame2.SomeIndexSelector.ItemIndex := ini.ReadInteger(section, 'SomeIndex', -1);
    DemoFrame2.SomeTextEdit.Text := ini.ReadString(section, 'SomeText', '');
  finally
    ini.Free;
  end;
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

procedure TDemoMainForm.SaveToStorage(const AFileName: string);
begin
  var ini := TMemInifile.Create(AFileName);
  try
    var section := Name;
    ini.WriteBool(section, 'SomeBoolean', SomeBooleanCheck.Checked);
    ini.WriteString(section, 'SomeEnum', TMyEnum.FromIndex(SomeEnumSelector.ItemIndex).AsString);
    ini.WriteInteger(section, 'SomeIndex', SomeIndexSelector.ItemIndex);
    ini.WriteString(section, 'SomeText', SomeTextEdit.Text);
    section := Name + '\' + DemoFrame1.Name;
    ini.WriteInteger(section, 'SomeIndex', DemoFrame1.SomeIndexSelector.ItemIndex);
    ini.WriteString(section, 'SomeText', DemoFrame1.SomeTextEdit.Text);
    section := Name + '\' + DemoFrame2.Name;
    ini.WriteInteger(section, 'SomeIndex', DemoFrame2.SomeIndexSelector.ItemIndex);
    ini.WriteString(section, 'SomeText', DemoFrame2.SomeTextEdit.Text);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TDemoMainForm.UpdateTitle;
begin
  TitleLabel.Caption := Name;
end;

end.
