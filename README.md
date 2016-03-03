# Raven-Delphi
The Sentry Client for Delphi

Raven-Delphi는 컴포넌트는 Sentry([www.getsentry.com](www.getsentry.com)) 로그 수접 서버의 클라이언트 인터페이스를 델파이로 구현한 컴포넌트입니다.



|Version | Support | 
|--------|---------|
| 7      |  Support|
| 8      |  Support|


### Setup ###

<pre>
{PROTOCOL}://{PUBLIC_KEY}:{SECRET_KEY}@{HOST}/{PATH}{PROJECT_ID}
</pre>


### 에러 전송 ###
<pre>
try
{시스템 로직}
except on E: Exception do
  RavenClient1.sendException(E)
end;

procedure TfxMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  LogBox.Lines.Add(E.Message);
  RavenClient1.sendException(E);
end;
</pre>


