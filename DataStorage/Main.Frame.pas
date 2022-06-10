unit Main.Frame;

interface

uses
  System.Classes, System.IniFiles,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Common.Frame;

type
  TDemoFrame = class(TFrame)
    SomeTextEdit: TLabeledEdit;
    SomeIndexSelector: TRadioGroup;
    TitleLabel: TLabel;
  protected
    procedure InternalInitDefaults; override;
    procedure InternalLoadFromStorage(Storage: TCustomIniFile; const ParentSection: string = ''); override;
    procedure InternalSaveToStorage(Storage: TCustomIniFile; const ParentSection: string = ''); override;
  public
    procedure UpdateTitle;
  end;

implementation

{$R *.dfm}

const
  cSomeIndex = 'SomeIndex';
  cSomeText = 'SomeText';

procedure TDemoFrame.InternalInitDefaults;
begin
  inherited;
  SomeIndexSelector.ItemIndex := -1;
  SomeTextEdit.Text := '';
end;

procedure TDemoFrame.InternalLoadFromStorage(Storage: TCustomIniFile; const ParentSection: string = '');
begin
  inherited;
  var section := GetStorageKey(ParentSection);
  SomeIndexSelector.ItemIndex := Storage.ReadInteger(section, cSomeIndex, -1);
  SomeTextEdit.Text := Storage.ReadString(section, cSomeText, '');
end;

procedure TDemoFrame.InternalSaveToStorage(Storage: TCustomIniFile; const ParentSection: string = '');
begin
  inherited;
  var section := GetStorageKey(ParentSection);
  Storage.WriteInteger(section, cSomeIndex, SomeIndexSelector.ItemIndex);
  Storage.WriteString(section, cSomeText, SomeTextEdit.Text);
end;

procedure TDemoFrame.UpdateTitle;
begin
  TitleLabel.Caption := Name;
end;

end.
