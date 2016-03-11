# Raven-Delphi
The Sentry Client for Delphi

Raven-Delphi는 컴포넌트는 Sentry([www.getsentry.com](www.getsentry.com)) 로그 수접 서버의 클라이언트 인터페이스를 델파이로 구현한 컴포넌트입니다.



|Version | Support | 
|--------|---------|
| 7      |  Support|
| 8      |  Support|


### Setup ###
Sentry([www.getsentry.com](www.getsentry.com)) 사이트에서 발급되는 (Project ID,Public_key, Secret_key) 를 컴포넌트 프로퍼티에 입력해주시면 됩니다. 
<pre>
{PROTOCOL}://{PUBLIC_KEY}:{SECRET_KEY}@{HOST}/{PATH}{PROJECT_ID}


RavenClient1.setHOST({HOST});
RavenClient1.setPORT({POROT});
RavenClient1.setPUBLIC_KEY({PUBLIC_KEY});
RavenClient1.setSECRET_KEY({SECRET_KEY});
RavenClient1.setPROJECT_ID({PROJECT_ID});
RavenClient1.setSENTRY_VERSION('7');
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


