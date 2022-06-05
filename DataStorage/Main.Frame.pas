unit Main.Frame;

interface

uses
  System.Classes, System.IniFiles,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask;

type
  TDemoFrame = class(TFrame)
    SomeTextEdit: TLabeledEdit;
    SomeIndexSelector: TRadioGroup;
    TitleLabel: TLabel;
  public
    procedure InitDefaults;
    procedure LoadFromStorage(Storage: TCustomIniFile; const ParentSection: string = ''); overload;
    procedure SaveToStorage(Storage: TCustomIniFile; const ParentSection: string = ''); overload;
    procedure UpdateTitle;
  end;

implementation

{$R *.dfm}

procedure TDemoFrame.InitDefaults;
begin
  SomeIndexSelector.ItemIndex := -1;
  SomeTextEdit.Text := '';
end;

procedure TDemoFrame.LoadFromStorage(Storage: TCustomIniFile; const ParentSection: string = '');
begin
  var section := Name;
  if ParentSection > '' then
    section := ParentSection + '\' + section;
  SomeIndexSelector.ItemIndex := Storage.ReadInteger(section, 'SomeIndex', -1);
  SomeTextEdit.Text := Storage.ReadString(section, 'SomeText', '');
end;

procedure TDemoFrame.SaveToStorage(Storage: TCustomIniFile; const ParentSection: string = '');
begin
  var section := Name;
  if ParentSection > '' then
    section := ParentSection + '\' + section;
  Storage.WriteInteger(section, 'SomeIndex', SomeIndexSelector.ItemIndex);
  Storage.WriteString(section, 'SomeText', SomeTextEdit.Text);
end;

procedure TDemoFrame.UpdateTitle;
begin
  TitleLabel.Caption := Name;
end;

end.
