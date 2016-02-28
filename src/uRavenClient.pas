unit uRavenClient;

interface


uses System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  System.RegularExpressions,
  uRavenConnection, uEvent;

type

  TRavenClient = class(TComponent)
    FRavenConnection: TRavenConnection;
    public
    FPROTOCOL:string;
    FDSN: string;
    FHOST: string;
    FPORT: integer;
    FPUBLIC_KEY: string;
    FSECRET_KEY: string;
    FPROJECT_ID: integer;
    FSENTRY_VERSION:string;
    procedure setPROTOCOL(_protocol:string);
    procedure setDSN;
    procedure setHOST(_host: string);
    procedure setPORT(_port: integer);
    procedure setSENTRY_VERSION(_version:string);
    procedure setPUBLIC_KEY(_public_key: string);
    procedure setSECRET_KEY(_secret_key: string);
    procedure setPROJECT_ID(_project_id: integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function sendEvent(event: BaseEvent):string;
    function sendMessage(msg: string):string;
    function sendException(exception: Exception):string;
    published
    property PROTOCOL:string read FPROTOCOL write setPROTOCOL ;
    property DSN: string read FDSN;
    property HOST: string read FHOST write setHOST;
    property PORT: integer read FPORT write setPORT default 9000;
    property SENTRY_VERSION:string read FSENTRY_VERSION write setSENTRY_VERSION;
    property PROJECT_ID: integer read FPROJECT_ID write setPROJECT_ID;
    property PUBLIC_KEY: string read FPUBLIC_KEY write setPUBLIC_KEY;
    property SECRET_KEY: string read FSECRET_KEY write setSECRET_KEY;
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
  FRavenConnection := TRavenConnection.Create(self);
end;

destructor TRavenClient.Destroy;
begin
  FreeAndNil(FRavenConnection);
  inherited;
end;

function TRavenClient.sendEvent(event: BaseEvent):string;
begin
  FRavenConnection.setPublicKey(FPUBLIC_KEY);
  FRavenConnection.setSecretKey(FSECRET_KEY);
  FRavenConnection.setProjectId( IntToStr(FPROJECT_ID));
  FRavenConnection.setDsn(self.FDSN);
  Result := FRavenConnection.send(event);
end;

function TRavenClient.sendException(exception: Exception):string;
var
event:TException;
begin
  event := TException.Create(Now);
  event.FException := exception;
  event.event_message := exception.Message;
  event.event_level := ERROR;
  event.event_culprit := exception.ClassName;
  FRavenConnection.setPublicKey(FPUBLIC_KEY);
  FRavenConnection.setSecretKey(FSECRET_KEY);
  FRavenConnection.setProjectId( IntToStr(FPROJECT_ID));
  FRavenConnection.setDsn(self.FDSN);
 Result :=  FRavenConnection.send(event);

end;

function TRavenClient.sendMessage(msg: string):string;
var
event:BaseEvent;
begin
  try
   FRavenConnection.setPublicKey(FPUBLIC_KEY);
  FRavenConnection.setSecretKey(FSECRET_KEY);
  FRavenConnection.setProjectId( IntToStr(FPROJECT_ID));
  FRavenConnection.setDsn(self.FDSN);
  event := BaseEvent.Create(Now);
  event.event_message := msg;
  event.event_level := INFO;
  event.event_culprit := 'raven-delphi';
   Result := FRavenConnection.send(event);

  except on E: Exception do

  end;


end;

procedure TRavenClient.setDSN;
begin
  self.FDSN := FPROTOCOL+'://' + FPUBLIC_KEY + ':' + FSECRET_KEY + '@' + FHOST + ':' +
    IntToStr(FPORT) + '/api/' + IntToStr(FPROJECT_ID) + '/store/';
    FRavenConnection.setDsn(Self.FDSN);
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

procedure TRavenClient.setSENTRY_VERSION(_version: string);
begin
Self.FSENTRY_VERSION := _version;
FRavenConnection.setVersion(Self.FSENTRY_VERSION);

end;

end.
