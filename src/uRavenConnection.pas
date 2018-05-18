unit uRavenConnection;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  IdBaseComponent, Generics.Collections, Generics.Defaults,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSLOpenSSL, uEvent,
  System.Threading;

{ TODO : 커넥션과 Client 를 분리 한다. }
const
  SENTRY_CLIENT = 'raven-pascal/2.0';
  USER_AGENT = 'User-Agent';
  SENTRY_AUTH = 'X-Sentry-Auth';
  DEFAULT_TIMEOUT = 5000;

const
  SENTRY_VERSION_7_FORMAT_STRING = '%s://%s:%s@%s/api/%s/store';
  SENTRY_VERSION_8_FORMAT_STRING = '%s://%s@%s/%s%s';

type
  TRavenConnection = class(TComponent)
    FIndyClient: TIdHTTP;
  private
    FSentry_version: string;
    FHost: string;
    FDsn: string;
    FProtocol: string;
    FPath: string;
    FPublicKey: String;
    FSecretKey: String;
    FProjecID: String;
  private
    procedure setHeader();
    function buildDSN(): string;
  public
    procedure Loaded; override;
    procedure setVersion(_version: string);
    procedure setDsn(_dsn: string);
    procedure setPublicKey(_public_key: string);
    procedure setSecretKey(_secret_key: string);
    procedure setProjectId(_project_id: string);
    procedure send(_event: BaseEvent);
    function test(): string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DNS: string read FDsn;
    property Host: string read FHost write FHost;
    property SentryVersion: string read FSentry_version write FSentry_version;
    property Protocol: string read FProtocol write FProtocol;
    property PublicKey: string read FPublicKey write setPublicKey;
    property SecretKey: string read FSecretKey write setSecretKey;
    property ProjectID: string read FProjecID write setProjectId;
  end;

procedure Register;

implementation

{ TRavenConnection }

procedure Register;
begin
  RegisterComponents('Raven', [TRavenConnection]);
end;

function TRavenConnection.buildDSN: string;
begin
  Result := Format(SENTRY_VERSION_7_FORMAT_STRING,
    [FProtocol, FPublicKey, FSecretKey, FHost, FPath, FProjecID]);
end;

constructor TRavenConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIndyClient := TIdHTTP.Create(self);
  FIndyClient.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(FIndyClient);
  FIndyClient.Request.CustomHeaders.Values[USER_AGENT] := SENTRY_CLIENT;
  FIndyClient.Request.CustomHeaders.Values['Content-Encoding'] :=
    'application/json';
  FIndyClient.Request.CustomHeaders.Values['Content-Type'] :=
    'application/octet-stream';
  buildDSN;
end;

destructor TRavenConnection.Destroy;
begin
  if FIndyClient <> nil then
    FreeAndNil(FIndyClient);
  inherited;
end;

procedure TRavenConnection.Loaded;
begin
  inherited;


end;

procedure TRavenConnection.send(_event: BaseEvent);
var
  send_stream: TStringStream;
  LTask: ITask;
begin
  buildDSN;
  LTask := TTask.Create(
    procedure()
    begin
      setHeader;
      send_stream := TStringStream.Create(_event.ToString);
      FIndyClient.Post(FDsn, send_stream);
    end);

end;

procedure TRavenConnection.setDsn(_dsn: string);
begin
  self.FDsn := _dsn;
end;

procedure TRavenConnection.setHeader;
var
  sentry_header: string;
begin
  sentry_header := '';
  sentry_header := sentry_header + 'Sentry sentry_version=' +
    FSentry_version + ',';
  sentry_header := sentry_header + 'sentry_client=' + SENTRY_CLIENT + ',';
  sentry_header := sentry_header + 'sentry_timestamp=' +
    IntToStr(DateTimeToUnix(Now)) + ',';
  sentry_header := sentry_header + 'sentry_key=' + FPublicKey + ',';
  sentry_header := sentry_header + 'sentry_secret=' + FSecretKey + '';
  FIndyClient.Request.CustomHeaders.Values[SENTRY_AUTH] := sentry_header;
end;

procedure TRavenConnection.setProjectId(_project_id: string);
begin
  self.FProjecID := _project_id;
  buildDSN;
end;

procedure TRavenConnection.setPublicKey(_public_key: string);
begin
  self.FPublicKey := _public_key;
  buildDSN;
end;

procedure TRavenConnection.setSecretKey(_secret_key: string);
begin
  self.FSecretKey := _secret_key;
  buildDSN;
end;

procedure TRavenConnection.setVersion(_version: string);
begin
  self.FSentry_version := _version;
end;

function TRavenConnection.test: string;
begin

end;

end.
