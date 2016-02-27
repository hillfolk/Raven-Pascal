unit uRaven;

interface

uses System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  System.RegularExpressions,
  uRavenConnection, uEvent;

type
  TRavenClient = class(TComponent)
    FRavenConnection: TRavenConnection;
    public
    FDSN: string;
    FHOST: string;
    FPORT: integer;
    FPUBLIC_KEY: string;
    FSECRET_KEY: string;
    FPROJECT_ID: integer;
    procedure setDSN;
    property DSN: string read FDSN;
    procedure setHOST(_host: string);
    procedure setPORT(_port: integer);
    procedure setPUBLIC_KEY(_public_key: string);
    procedure setSECRET_KEY(_secret_key: string);
    procedure setPROJECT_ID(_project_id: integer);
    property HOST: string read FHOST write setHOST;
    property PORT: integer read FPORT write setPORT;
    property PROJECT_ID: integer read FPROJECT_ID write setPROJECT_ID;
    property PUBLIC_KEY: string read FPUBLIC_KEY write setPUBLIC_KEY;
    property SECRET_KEY: string read FSECRET_KEY write setSECRET_KEY;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure sendEvent(event: BaseEvent);
    procedure sendMessage(msg: TMessage);
    procedure sendException(exception: TException);

  end;

implementation

{ TRaven }

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

procedure TRavenClient.sendEvent(event: BaseEvent);
begin
  FRavenConnection.send(event);
end;

procedure TRavenClient.sendException(exception: TException);
begin
  // Temp Code
  FRavenConnection.send(exception);

end;

procedure TRavenClient.sendMessage(msg: TMessage);
begin
  // Temp Code
  FRavenConnection.send(msg);

end;

procedure TRavenClient.setDSN;
begin
  self.FDSN := 'http://' + FPUBLIC_KEY + ':' + FSECRET_KEY + '@' + FHOST + ':' +
    IntToStr(FPORT) + '/api/' + IntToStr(FPROJECT_ID) + '/store/';
end;

procedure TRavenClient.setHOST(_host: string);
begin
  self.FHOST := _host;
  setDSN
end;

procedure TRavenClient.setPORT(_port: integer);
begin
  self.FPORT := _port;
end;

procedure TRavenClient.setPROJECT_ID(_project_id: integer);
begin
  self.FPROJECT_ID := _project_id;
end;

procedure TRavenClient.setPUBLIC_KEY(_public_key: string);
begin
  self.FPUBLIC_KEY := _public_key;
end;

procedure TRavenClient.setSECRET_KEY(_secret_key: string);
begin
  self.FSECRET_KEY := _secret_key;
end;

end.
