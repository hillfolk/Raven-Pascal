unit uHMAC;

interface

uses
  System.SysUtils,
  EncdDecd,
  IdHMAC,
  IdSSLOpenSSL,
  IdHash,
  IdGlobal;

type
  THMACUtils<T: TIdHMAC, constructor> = class
  public
    class function HMAC(aKey, aMessage: RawByteString): TIdBytes;
    class function HMAC_HexStr(aKey, aMessage: RawByteString): RawByteString;
    class function HMAC_Base64(aKey, aMessage: RawByteString): RawByteString;
  end;

implementation

class function THMACUtils<T>.HMAC(aKey, aMessage: RawByteString): TIdBytes;
var
  _HMAC: T;
begin
  if not IdSSLOpenSSL.LoadOpenSSLLibrary then Exit;
  _HMAC:= T.Create;
  try
    _HMAC.Key := ToBytes(aKey);
    Result:= _HMAC.HashValue(ToBytes(aMessage));
  finally
    _HMAC.Free;
  end;
end;

class function THMACUtils<T>.HMAC_HexStr(aKey, aMessage: RawByteString): RawByteString;
var
  I: Byte;
begin
  Result:= '0x';
  for I in HMAC(aKey, aMessage) do
    Result:= Result + IntToHex(I, 2);
end;

class function THMACUtils<T>.HMAC_Base64(aKey, aMessage: RawByteString): RawByteString;
var
  _HMAC: TIdBytes;
begin
  _HMAC:= HMAC(aKey, aMessage);
  Result:= EncodeBase64(_HMAC, Length(_HMAC));
end;

end.
