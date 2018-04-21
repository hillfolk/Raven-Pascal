unit uRavenConnection;

interface

uses
System.SysUtils, System.Variants, System.Classes ,System.DateUtils, IdBaseComponent,Generics.Collections,Generics.Defaults,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,uEvent;

const
SENTRY_CLIENT = 'raven-delphi/2.0';
USER_AGENT = 'User-Agent';
SENTRY_AUTH = 'X-Sentry-Auth';
DEFAULT_TIMEOUT = 5000;

type
TRavenConnection = class(TComponent)
  FIndyClient:TIdHTTP;
  private
  sentry_version:string;
  FDsn:string;
  FPublicKey:String;
  FSecretKey:String;
  FProjecID:String;
  private
  procedure setHeader();
  public
  procedure setVersion(_version:string);
  procedure setDsn(_dsn:string);
  procedure setPublicKey(_public_key:string);
  procedure setSecretKey(_secret_key:string);
  procedure setProjectId(_project_id:string);
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  property DNS: string read FDsn write setDsn;
  property PublicKey: string read FPublicKey write setPublicKey;
  property SecretKey: string read FSecretKey write setSecretKey;
  property ProjectID: string read FProjecID write setProjectId;
  function send(_event:BaseEvent):string;
  function test():string;
  end;

implementation

{ TRavenClient }

constructor TRavenConnection.Create(AOwner: TComponent);
begin
  inherited;
  FIndyClient := TIdHTTP.Create(self);

  FIndyClient.Request.CustomHeaders.Values[USER_AGENT] := SENTRY_CLIENT;
  FIndyClient.Request.CustomHeaders.Values['Content-Encoding'] := 'application/json';
  FIndyClient.Request.CustomHeaders.Values['Content-Type'] := 'application/octet-stream';

end;

destructor TRavenConnection.Destroy;
begin
  if FIndyClient <> nil then
  FreeAndNil(FIndyClient);
  inherited;
end;

function TRavenConnection.send(_event: BaseEvent):string;
var
send_stream:TStringStream;
begin
setHeader;
send_stream := TStringStream.Create(_event.ToString);
Result := FIndyClient.Post(FDsn,send_stream);
end;

procedure TRavenConnection.setDsn(_dsn:string);
begin
self.FDsn := _dsn;
end;

procedure TRavenConnection.setHeader;
var
sentry_header : string;
begin
sentry_header :=  '';
sentry_header := sentry_header+'Sentry sentry_version='+sentry_version+',';
sentry_header := sentry_header+'sentry_client='+SENTRY_CLIENT+',';
sentry_header := sentry_header+'sentry_timestamp=' +IntToStr(DateTimeToUnix(Now))+',';
sentry_header := sentry_header+'sentry_key='+FPublicKey+ ',';
sentry_header := sentry_header+'sentry_secret='+FSecretKey+ '';
FIndyClient.Request.CustomHeaders.Values[SENTRY_AUTH] := sentry_header;
end;

procedure TRavenConnection.setProjectId(_project_id: string);
begin
  Self.FProjecID :=  _project_id;
end;

procedure TRavenConnection.setPublicKey(_public_key: string);
begin
  self.FPublicKey :=_public_key;
end;

procedure TRavenConnection.setSecretKey(_secret_key: string);
begin
  Self.FSecretKey := _secret_key;
end;

procedure TRavenConnection.setVersion(_version: string);
begin
  self.sentry_version := _version;
end;

function TRavenConnection.test: string;
begin

end;

end.
