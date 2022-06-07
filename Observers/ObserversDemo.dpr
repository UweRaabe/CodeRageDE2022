program ObserversDemo;

uses
  Vcl.Forms,
  Cmon.Messaging.Dialogs.Vcl,
  DataTypes in 'DataTypes.pas',
  ObservableData in 'ObservableData.pas',
  Main.Form in 'Main.Form.pas' {DemoMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDemoMainForm, DemoMainForm);
  Application.Run;
end.
