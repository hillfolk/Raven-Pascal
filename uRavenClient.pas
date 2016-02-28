unit uRavenClient;

interface

uses
  System.SysUtils, System.Classes;

type
  TRaventClient = class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Raven', [TRaventClient]);
end;

end.
