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
  private
    FData: TData;
    FLogHandlerId: Integer;
    procedure DoLogMessage(const AMessage: string);
  strict protected
    function CreateData: TData;
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
  Cmon.Logging, Cmon.Observers.Vcl,
  ObservableData;

constructor TDemoMainForm.Create(AOwner: TComponent);
begin
  inherited;

  { register to receive log messages }
  LogMemo.Clear;
  FLogHandlerId := TLog.Subscribe(DoLogMessage);

  FData := CreateData;

  { link observers }
  MyStringEdit.AddValidator(Data.IsMyStringValid);
  MyStringEdit.AddObserver(procedure(AValue: string) begin Data.MyString := AValue end);
  MyLinesMemo.AddObserver(procedure(AValue: TStrings) begin Data.MyLines := AValue end);
  MySelectedComboBox.AddObserver(procedure(AValue: Integer) begin Data.MySelectedIndex := AValue end);
  MySelectedComboBox.AddObserver(procedure(AValue: string) begin Data.MySelected := AValue end);
  MyListItemListBox.AddObserver(procedure(AValue: Integer) begin Data.MyListItemIndex := AValue end);
  MyListItemListBox.AddObserver(procedure(AValue: string) begin Data.MyListItem := AValue end);
end;

destructor TDemoMainForm.Destroy;
begin
  TLog.Unsubscribe(FLogHandlerId);
  FData.Free;
  inherited Destroy;
end;

function TDemoMainForm.CreateData: TData;
begin
  var tmp := TObservableData.Create;
  tmp.AddObserver<string>('MyString', procedure(AValue: string) begin MyStringEdit.Text := AValue end);
  tmp.AddObserver<TStrings>('MyLines', procedure(AValue: TStrings) begin MyLinesMemo.Lines := AValue end);
  tmp.AddObserver<Integer>('MySelectedIndex', procedure(AValue: Integer) begin MySelectedComboBox.ItemIndex := AValue end);
  tmp.AddObserver<string>('MySelected', procedure(AValue: string) begin MySelectedComboBox.Text := AValue end);
  tmp.AddObserver<Integer>('MyListItemIndex', procedure(AValue: Integer) begin MyListItemListBox.ItemIndex := AValue end);

  Result := tmp;
end;

procedure TDemoMainForm.DoLogMessage(const AMessage: string);
begin
  LogMemo.Lines.Add(AMessage);
end;

end.
