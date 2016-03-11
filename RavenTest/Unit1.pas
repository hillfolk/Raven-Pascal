unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,System.DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,uRavenClient, Vcl.ExtCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,IdHMACSHA1,IdHashMessageDigest,
  Vcl.AppEvnts, IdIntercept, IdLogBase, IdLogEvent, IdGlobal;
  const
  hmPOST = 0;
  hmGET = 1;

type
  TForm1 = class(TForm)
    IdHTTP:TIdHTTP;
    LogBox: TMemo;
    Button1: TButton;
    rgHttpMethod: TRadioGroup;
    edtAURL: TEdit;
    parmeterGroup: TGroupBox;
    Timer1: TTimer;
    tmrLabel: TLabel;
    edtEvent_Id: TEdit;
    edtCulprit: TEdit;
    edtTimestamp: TEdit;
    edtMessage: TEdit;
    Label1: TLabel;
    edtTagKey: TEdit;
    edtCulpri: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtTagValue: TEdit;
    edtType: TEdit;
    Label6: TLabel;
    edtValue: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtModule: TEdit;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;
    RavenClient1: TRavenClient;
    ApplicationEvents1: TApplicationEvents;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure RavenClient1Send(Sender: TObject; ALog: string);
  private
    { Private declarations }
    function Post(AURL:string;data:TStringStream):string;
    function Get(AURL:string):string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  UnixStartDate: TDateTime = 25569.0; // 01/01/1970



procedure TForm1.ApplicationEvents1Exception(Sender: TObject; E: Exception);
var
result_msg:string;
begin
result_msg := RavenClient1.sendException(E);
LogBox.Lines.Add(E.Message);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
temp_Strings:TStrings;
url:string;
temp_string:string;
input_string:string;
time_stamp:string;
public_key:string;
input_stream:TStringStream;
sentry_header,api_secret,secret_key:string;
header:TStrings;
begin
url := edtAURL.Text;
input_string := 'dfsdf';
time_stamp :=  IntToStr( DateTimeToUnix(Now));
if rgHttpMethod.ItemIndex = hmPOST then
begin
{
           'User-Agent': client_string,
            'X-Sentry-Auth': auth_header,
            'Content-Encoding': self.get_content_encoding(),
            'Content-Type': 'application/octet-stream',

       https://f273091f96ef44bd9e5366f0fa935e28:236c3cab7336475c895abaa9b26af612@app.getsentry.com/67942
}
public_key := 'f273091f96ef44bd9e5366f0fa935e28';
secret_key := '236c3cab7336475c895abaa9b26af612';
api_secret := 'd20cdb86d97611e58e390242ac11001a';

header := TStringList.Create;
sentry_header :=  '';
sentry_header := sentry_header+'Sentry sentry_version=7,';
sentry_header := sentry_header+'sentry_client=raven-delphi/1.0,';
sentry_header := sentry_header+'sentry_timestamp=' + time_stamp+',';
sentry_header := sentry_header+'sentry_key='+public_key+ ',';
sentry_header := sentry_header+'sentry_secret='+secret_key+ '';

//sentry_header := sentry_header+'sentry_signature='+THMACUtils<TIdHMACSHA1>.HMAC_HexStr(public_key,time_stamp+' '+edtMessage.Text) ;
IdHTTP.Request.CustomHeaders.Values['X-Sentry-Auth'] := sentry_header;
//IdHTTP.Request.CustomHeaders.Values['X-Sentry-Token'] := api_secret;
//LogBox.Lines.AddStrings(IdHTTP.Request.CustomHeaders);
//LogBox.Lines.AddStrings(header);
input_string := '{ "event_id" : "'+ edtEvent_Id.Text  + '",'
               + ' "culprit" : "'+ edtCulprit.Text + '",'
               + ' "timestamp" : "'+ edtTimestamp.Text + '",'
               + ' "message" : "'+ edtMessage.Text + '",'
               + ' "tags" : {"'+
               edtTagKey.Text+'":"' + edtTagValue.Text + '"},'
               +'"exception":[{'
               +'"type" : "'+ edtType.Text +'",'
               +'"value" : "'+ edtValue.Text +'",'
               +'"module" : "'+ edtModule.Text +'"}]}';

input_stream := TStringStream.Create(input_string);

temp_string :=  Self.Post(url,input_stream);
end;

if rgHttpMethod.ItemIndex = hmGET then
begin
  temp_string:=  Self.Get(url);
end;

end;

function GUID4ToString(const Guid: TGUID): string;
begin
  SetLength(Result, 16);
  StrLFmt(PChar(Result), 16,'%.8x%.4x%.4x%',   // do not localize
    [Guid.D1, Guid.D2, Guid.D3]);
   Result :=  LowerCase(Result);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
uid:TGuid;
Result: String;
 strAnsiName : AnsiString;
 strName : String;
 i:Integer;
begin
 Result := '';
 if CreateGuid(uid) = S_OK then
  begin
   Result :=  GUID4ToString(uid);

   edtEvent_Id.Text := Result;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
result_message:string;
begin
//'http://2287716fddd94b16b5cf19c49b05fb35:5a52c3092b4742ce9532f32bfad285dc@sentry.hillfolk.org:32779/api/2/store/';
//RavenClient1.setHOST('sentry.hillfolk.org');
//RavenClient1.setPORT(32779);
//RavenClient1.setPUBLIC_KEY('2287716fddd94b16b5cf19c49b05fb35');
//RavenClient1.setSECRET_KEY('5a52c3092b4742ce9532f32bfad285dc');
//RavenClient1.setPROJECT_ID(2);
//RavenClient1.setSENTRY_VERSION('7');
//result_message := RavenClient1.sendMessage(edtMessage.Text);



end;

function TForm1.Get(AURL:string): string;
begin
try
result := IdHTTP.Get(AURL);
except on E: Exception do

end;

end;

function TForm1.Post(AURL:string;data: TStringStream): string;
begin
try
result := IdHTTP.Post(AURL,data);
except on E: Exception do
 LogBox.Lines.Add( RavenClient1.sendException(E));
end;
end;

procedure TForm1.RavenClient1Send(Sender: TObject; ALog: string);
begin
LogBox.Lines.Add('Message:'+ALog);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
tmrLabel.Caption := IntToStr(DateTimeToUnix(Now));

end;

end.
