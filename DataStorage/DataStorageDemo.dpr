program DataStorageDemo;

uses
  Vcl.Forms,
  Common.DataStorage in 'Common.DataStorage.pas',
  Common.Frame in 'Common.Frame.pas',
  Common.Form in 'Common.Form.pas',
  Main.Frame in 'Main.Frame.pas' {DemoFrame: TFrame},
  Main.Form in 'Main.Form.pas' {DemoMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDemoMainForm, DemoMainForm);
  Application.Run;
end.
