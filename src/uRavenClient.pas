unit uRavenClient;

interface

uses System.SysUtils, System.Variants, System.Classes, System.DateUtils,
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
  public
    FPROTOCOL: string;
    FDSN: string;
    FHOST: string;
    FPORT: integer;
    FPUBLIC_KEY: string;
    FSECRET_KEY: string;
    FPROJECT_ID: integer;
    FSENTRY_VERSION: integer;
    procedure setPROTOCOL(_protocol: string);
    procedure setDSN;
    procedure setHOST(_host: string);
    procedure setPORT(_port: integer);
    procedure setSENTRY_VERSION(_version: integer);
    procedure setPUBLIC_KEY(_public_key: string);
    procedure setSECRET_KEY(_secret_key: string);
    procedure setPROJECT_ID(_project_id: integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure sendEvent(event: BaseEvent);
    function sendMessage(msg: string): string;
    function sendException(exception: exception): string;
  published
    property PROTOCOL: string read FPROTOCOL write setPROTOCOL;
    property DSN: string read FDSN;
    property HOST: string read FHOST write setHOST;
    property PORT: integer read FPORT write setPORT default 9000;
    property SENTRY_VERSION: integer read FSENTRY_VERSION
      write setSENTRY_VERSION default 8;
    property PROJECT_ID: integer read FPROJECT_ID write setPROJECT_ID;
    property PUBLIC_KEY: string read FPUBLIC_KEY write setPUBLIC_KEY;
    property SECRET_KEY: string read FSECRET_KEY write setSECRET_KEY;
    property OnSend: TOnSend read FOnSend write FOnSend;
  end;

const
  SENTRY_VERSION_7_FORMAT_STRING = '%s://%s:%s@%s/%s%d';
  SENTRY_VERSION_8_FORMAT_STRING = '%s://%s@%s/%s%d';

procedure Register;

implementation

{ TRaven }

procedure Register;
begin
  RegisterComponents('RavenClient', [TRavenClient]);
end;

constructor TRavenClient.Create(AOwner: TComponent);
begin
  inherited;
  FRavenConnection := TRavenConnection.Create(self);
end;

destructor TRavenClient.Destroy;
begin
  FreeAndNil(FRavenConnection);
  inherited;
end;

procedure TRavenClient.DoSend(ALog: string);
begin
  if Assigned(FOnSend) then
    FOnSend(self, ALog);
end;

procedure TRavenClient.sendEvent(event: BaseEvent);
begin
  FRavenConnection.setPublicKey(FPUBLIC_KEY);
  FRavenConnection.setSecretKey(FSECRET_KEY);
  FRavenConnection.setProjectId(IntToStr(FPROJECT_ID));
  FRavenConnection.setDSN(self.FDSN);
  DoSend(event.ToString);
  FRavenConnection.send(event);
end;

function TRavenClient.sendException(exception: exception): string;
var
  event: TException;
begin
  event := TException.Create(Now);
  event.FException := exception;
  event.event_message := exception.Message;
  event.event_level := ERROR;
  event.event_culprit := exception.ClassName;
  FRavenConnection.setPublicKey(FPUBLIC_KEY);
  FRavenConnection.setSecretKey(FSECRET_KEY);
  FRavenConnection.setProjectId(IntToStr(FPROJECT_ID));
  FRavenConnection.setDSN(self.FDSN);
  DoSend(event.ToString);
  FRavenConnection.send(event);

end;

function TRavenClient.sendMessage(msg: string): string;
var
  event: BaseEvent;
begin
  try
    FRavenConnection.setPublicKey(FPUBLIC_KEY);
    FRavenConnection.setSecretKey(FSECRET_KEY);
    FRavenConnection.setProjectId(IntToStr(FPROJECT_ID));
    FRavenConnection.setDSN(self.FDSN);
    event := BaseEvent.Create(Now);
    event.event_message := msg;
    event.event_level := INFO;
    event.event_culprit := 'raven-pascal';
    DoSend(event.ToString);
    FRavenConnection.send(event);
  except
    on E: exception do

  end;

end;

procedure TRavenClient.setDSN;
begin
  case SENTRY_VERSION of
    7:
      begin
        FDSN := format(SENTRY_VERSION_7_FORMAT_STRING, [])
      end;
    8:
      begin
        FDSN := format(SENTRY_VERSION_8_FORMAT_STRING, [])
      end

  else

  end;
  // self.FDSN := format(,)
  FRavenConnection.setDSN(self.FDSN);
end;

procedure TRavenClient.setHOST(_host: string);
begin
  self.FHOST := _host;
  setDSN;
end;

procedure TRavenClient.setPORT(_port: integer);
begin
  self.FPORT := _port;
  setDSN;
end;

procedure TRavenClient.setPROJECT_ID(_project_id: integer);
begin
  self.FPROJECT_ID := _project_id;
  setDSN;
end;

procedure TRavenClient.setPROTOCOL(_protocol: string);
begin
  FPROTOCOL := _protocol;
  setDSN;
end;

procedure TRavenClient.setPUBLIC_KEY(_public_key: string);
begin
  self.FPUBLIC_KEY := _public_key;
  setDSN;
end;

procedure TRavenClient.setSECRET_KEY(_secret_key: string);
begin
  self.FSECRET_KEY := _secret_key;
  setDSN;
end;

procedure TRavenClient.setSENTRY_VERSION(_version: integer);
begin
  self.FSENTRY_VERSION := _version;
  FRavenConnection.setVersion(self.FSENTRY_VERSION);

end;

end.
