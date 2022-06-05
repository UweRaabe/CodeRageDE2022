unit Main.Frame;

interface

uses
  System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask;

type
  TDemoFrame = class(TFrame)
    SomeTextEdit: TLabeledEdit;
    SomeIndexSelector: TRadioGroup;
    TitleLabel: TLabel;
  public
    procedure UpdateTitle;
  end;

implementation

{$R *.dfm}

procedure TDemoFrame.UpdateTitle;
begin
  TitleLabel.Caption := Name;
end;

end.
