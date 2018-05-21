unit uRavenClient;

interface

uses System.SysUtils, System.Classes, System.Variants, System.DateUtils,
  System.RegularExpressions,
  uRavenConnection, uEvent;

{ TODO : DSN 을 Connect 에서 지정하게 하도록 변경 }
type
  TOnSend = procedure(Sender: TObject; ALog: String) of object;

  TRavenClient = class(TComponent)
    FRavenConnection: TRavenConnection;
  private
    FOnSend: TOnSend;
    procedure DoSend(ALog: string);
    function getConnection: TRavenConnection;
    procedure setConnection(const Value: TRavenConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure sendEvent(event: BaseEvent);
    procedure Log(AMessage: string);
    function sendMessage(msg: string): string;
    function sendException(AException: exception): string;
  published
    property OnSend: TOnSend read FOnSend write FOnSend;
    property RavenConnection: TRavenConnection read getConnection
      write setConnection;
  end;

procedure Register;

implementation

{ TRaven }

procedure Register;
begin
  RegisterComponents('Raven', [TRavenClient]);
end;

constructor TRavenClient.Create(AOwner: TComponent);
begin
  inherited;
  FRavenConnection := nil;
end;

destructor TRavenClient.Destroy;
begin
  inherited;
end;

procedure TRavenClient.DoSend(ALog: string);
begin
  if Assigned(FOnSend) then
    FOnSend(self, ALog);
end;

function TRavenClient.getConnection: TRavenConnection;
begin
  Result := FRavenConnection;
end;

procedure TRavenClient.Log(AMessage: string);
begin
  // Writeln(Format('Exception:Raven-Pascal On %s  ', [AMessage]));
end;

procedure TRavenClient.sendEvent(event: BaseEvent);
begin
  DoSend(event.ToString);
  FRavenConnection.send(event);
end;

function TRavenClient.sendException(AException: exception): string;
var
  event: TException;
begin
  try
    if Assigned(FRavenConnection) then
    begin
      event := TException.Create(Now);
      event.FException := AException;
      event.event_message := AException.Message;
      event.event_level := ERROR;
      event.event_culprit := AException.ClassName;
      DoSend(event.ToString);
      FRavenConnection.send(event);
    end;
  except
    on E: exception do
      Log(E.Message);
  end;
end;

function TRavenClient.sendMessage(msg: string): string;
var
  event: BaseEvent;
begin
  try
    if Assigned(FRavenConnection) then
    begin
      event := BaseEvent.Create(Now);
      event.event_message := msg;
      event.event_level := INFO;
      event.event_culprit := 'raven-pascal';
      DoSend(event.ToString);
      FRavenConnection.send(event);
    end;
  except
    on E: exception do
      Log(E.Message);
  end;

end;

procedure TRavenClient.setConnection(const Value: TRavenConnection);
begin
  FRavenConnection := Value;
end;

end.
