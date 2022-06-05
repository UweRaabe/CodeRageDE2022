unit Main.Form;

interface

uses
  System.Classes, System.Messaging,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  DataTypes;

type
  TDemoMainForm = class(TForm)
    LogMemo: TMemo;
    MyStringEdit: TEdit;
    MyLinesMemo: TMemo;
    MySelectedComboBox: TComboBox;
    MyListItemListBox: TListBox;
    procedure MyLinesMemoExit(Sender: TObject);
    procedure MyListItemListBoxClick(Sender: TObject);
    procedure MyListItemListBoxExit(Sender: TObject);
    procedure MySelectedComboBoxChange(Sender: TObject);
    procedure MySelectedComboBoxExit(Sender: TObject);
    procedure MySelectedComboBoxSelect(Sender: TObject);
    procedure MyStringEditExit(Sender: TObject);
    procedure MyStringEditKeyPress(Sender: TObject; var Key: Char);
  private
    FData: TData;
    FLogHandlerId: Integer;
    procedure DoLogMessage(const AMessage: string);
    procedure UpdateMyLines;
    procedure UpdateMyListItem;
    procedure UpdateMySelected;
    procedure UpdateMyString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Data: TData read FData;
  end;

var
  DemoMainForm: TDemoMainForm;

implementation

{$R *.dfm}

uses
  System.SysUtils,
  Cmon.Logging, Cmon.Observers.Vcl;

constructor TDemoMainForm.Create(AOwner: TComponent);
begin
  inherited;

  { register to receive log messages }
  LogMemo.Clear;
  FLogHandlerId := TLog.Subscribe(DoLogMessage);

  FData := TData.Create;

  { load initial data }
  MyStringEdit.Text := Data.MyString;
  MyLinesMemo.Lines := Data.MyLines;
  MySelectedComboBox.Text := Data.MySelected;
  MySelectedComboBox.ItemIndex := Data.MySelectedIndex;
  MyListItemListBox.ItemIndex := Data.MyListItemIndex;

end;

destructor TDemoMainForm.Destroy;
begin
  TLog.Unsubscribe(FLogHandlerId);
  FData.Free;
  inherited Destroy;
end;

procedure TDemoMainForm.DoLogMessage(const AMessage: string);
begin
  LogMemo.Lines.Add(AMessage);
end;

procedure TDemoMainForm.MyLinesMemoExit(Sender: TObject);
begin
  UpdateMyLines;
end;

procedure TDemoMainForm.MyListItemListBoxClick(Sender: TObject);
begin
  UpdateMyListItem;
end;

procedure TDemoMainForm.MyListItemListBoxExit(Sender: TObject);
begin
  UpdateMyListItem;
end;

procedure TDemoMainForm.MySelectedComboBoxChange(Sender: TObject);
begin
  UpdateMySelected;
end;

procedure TDemoMainForm.MySelectedComboBoxExit(Sender: TObject);
begin
  UpdateMySelected;
end;

procedure TDemoMainForm.MySelectedComboBoxSelect(Sender: TObject);
begin
  UpdateMySelected;
end;

procedure TDemoMainForm.MyStringEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    UpdateMyString;
  end;
end;

procedure TDemoMainForm.MyStringEditExit(Sender: TObject);
begin
  UpdateMyString;
end;

procedure TDemoMainForm.UpdateMyLines;
begin
  Data.MyLines := MyLinesMemo.Lines;
end;

procedure TDemoMainForm.UpdateMyListItem;
begin
  Data.MyListItemIndex := MyListItemListBox.ItemIndex;
  if MyListItemListBox.ItemIndex < 0 then
    Data.MyListItem := ''
  else
    Data.MyListItem := MyListItemListBox.Items[MyListItemListBox.ItemIndex];
end;

procedure TDemoMainForm.UpdateMySelected;
begin
  Data.MySelectedIndex := MySelectedComboBox.ItemIndex;
  Data.MySelected := MySelectedComboBox.Text;
end;

procedure TDemoMainForm.UpdateMyString;
begin
  var newValue := MyStringEdit.Text;
  if MyStringEdit.AutoSelect and MyStringEdit.Focused then
    MyStringEdit.SelectAll;
  if Data.IsMyStringValid(newValue) then
    Data.MyString := newValue
  else
    Abort;
end;

end.
