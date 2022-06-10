unit Main.Frame;

interface

uses
  System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Cmon.DataStorage,
  Common.Frame;

type
  TDemoFrame = class(TFrame)
    SomeTextEdit: TLabeledEdit;
    SomeIndexSelector: TRadioGroup;
    TitleLabel: TLabel;
  private
    function GetSomeIndex: Integer;
    function GetSomeText: string;
    procedure SetSomeIndex(const Value: Integer);
    procedure SetSomeText(const Value: string);
  protected
    procedure InternalInitDefaults(Storage: TDataStorage); override;
    procedure InternalLoadFromStorage(Storage: TDataStorage); override;
    procedure InternalSaveToStorage(Storage: TDataStorage); override;
  public
    procedure UpdateTitle;
    property SomeIndex: Integer read GetSomeIndex write SetSomeIndex;
    property SomeText: string read GetSomeText write SetSomeText;
  end;

implementation

{$R *.dfm}

const
  cSomeIndex = 'SomeIndex';
  cSomeText = 'SomeText';

function TDemoFrame.GetSomeIndex: Integer;
begin
  Result := SomeIndexSelector.ItemIndex;
end;

function TDemoFrame.GetSomeText: string;
begin
  Result := SomeTextEdit.Text;
end;

procedure TDemoFrame.SetSomeIndex(const Value: Integer);
begin
  SomeIndexSelector.ItemIndex := Value;
end;

procedure TDemoFrame.SetSomeText(const Value: string);
begin
  SomeTextEdit.Text := Value;
end;

procedure TDemoFrame.InternalInitDefaults(Storage: TDataStorage);
begin
  inherited;
  SomeIndex := -1;
  SomeText := '';
end;

procedure TDemoFrame.InternalLoadFromStorage(Storage: TDataStorage);
begin
  inherited;
  SomeIndex := Storage.ReadInteger(cSomeIndex, -1);
  SomeText := Storage.ReadString(cSomeText, '');
end;

procedure TDemoFrame.InternalSaveToStorage(Storage: TDataStorage);
begin
  inherited;
  Storage.WriteInteger(cSomeIndex, SomeIndex);
  Storage.WriteString(cSomeText, SomeText);
end;

procedure TDemoFrame.UpdateTitle;
begin
  TitleLabel.Caption := Name;
end;

end.
