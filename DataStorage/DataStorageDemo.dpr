program DataStorageDemo;

uses
  Vcl.Forms,
  Cmon.DataStorage.Target,
  Cmon.DataStorage.Inifile,
  Cmon.DataStorage.JSON,
  Common.Frame in 'Common.Frame.pas',
  Common.Form in 'Common.Form.pas',
  Main.Data.Types in 'Main.Data.Types.pas',
  Main.Frame in 'Main.Frame.pas' {DemoFrame: TFrame},
  Main.Form in 'Main.Form.pas' {DemoMainForm};

{$R *.res}

procedure PreInitialize;
begin
  { This sets the extension (and thus the handler) which is used for automatic load and Save of storage data }
  TCustomStorageTarget.DefaultFileExtension := TIniStorageTarget.FileExtension;
  { This sets the default extension for the settings file used for manual Load and Save of storage data in DemoMainForm }
  TDemoMainForm.SettingsFileExtension := TJSONStorageTarget.FileExtension;
end;

begin
  PreInitialize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDemoMainForm, DemoMainForm);
  Application.Run;
end.
