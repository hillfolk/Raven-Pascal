# Raven-Pascal
The Sentry Client for Object Pascal

Raven-Pascal는 컴포넌트는 Sentry([https://www.sentry.io](https://www.sentry.io)) 로그 수접 서버의 클라이언트 인터페이스를 파스칼로 구현한 컴포넌트입니다.


|Version | Support | 
|--------|---------|
| 7      |  Support|
| 8      |  Support|


### Setup ###
Sentry([https://www.sentry.io](www.sentry.io)) 사이트에서 발급되는 (Project ID,Public_key, Secret_key) 를 컴포넌트 프로퍼티에 입력해주시면 됩니다.

* 이번 업데이트 부터 RavenConnection 컴포넌트에 직접 Sentry 서버의 셋팅을 하도록 수정 하였다 .

### RavenConnection Setup ###

|Property |Data	    | 
|--------|---------|
| ProjectID      |  Sentry Project Id|
| Protocol      |  Https or Http|
| PublicKey     |  PROJECT PublicKey|
| SecretKey      |  PROJECT SecretKey|
| SentryVersion      |  Sentry Server Version|



### Exception ###
<pre>
try
{ Code }
except on E: Exception do
  RavenClient1.sendException(E)
end;

procedure TfxMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  LogBox.Lines.Add(E.Message);
  RavenClient1.sendException(E);
end;
</pre>

### Message ###
<pre>
RavenClient1.sendMessage('Message');
</pre>




