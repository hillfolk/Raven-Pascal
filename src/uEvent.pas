unit uEvent;

interface

uses System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  System.Generics.Collections, TypInfo;

const
  TAGS_LENGTH = 10;
  MODULE_LENGTH = 10;

type
  ELevel = (FATAL, ERROR, WARNING, INFO, DEBUG);

type
  BaseEvent = class(TObject)
    event_id: string;
    event_message: string;
    event_timestamp: string;
    event_level: ELevel;
    event_logger: string;
    event_platform: string;
    event_culprit: string;
    server_name: string;
    release: string;
    tags: TDictionary<String, String>; // Not Support
    extra: TDictionary<String, String>; // Not Support
    fingerprint: string; // Not Support
  private
    function tagsToJson(tags: TDictionary<string, string>): string;
    function extraToJson(extra: TDictionary<string, string>): string;
  public
    constructor Create(time: TDateTime);
    procedure setMessage(_message: string);
    procedure setLevel(_level: ELevel);
    procedure setLogger(_logger: string);
    procedure setPlatform(_platform: string);
    procedure setCulprit(_culprit: string);
    procedure setServerName(_serverName: string);
    procedure setRelease(_release: string);
    function ToString(): string; virtual;
  end;
  //

type
  TException = class(BaseEvent)
  FException:Exception;
  public
    function ToString(): string;
  end;

type
  TMessage = class(BaseEvent)
  public
    function ToString(): string; override;

  end;

type
  TQuery = class(BaseEvent)
  public
    function ToString(): string; override;

  end;

implementation

{ BaseEvent }

function GUID4ToString(const Guid: TGUID): string;
begin
  SetLength(Result, 16);
  StrLFmt(PChar(Result), 16, '%.8x%.4x%.4x%', // do not localize
    [Guid.D1, Guid.D2, Guid.D3]);
  Result := LowerCase(Result);
end;

constructor BaseEvent.Create(time: TDateTime);
var
  Guid: TGUID;
  ISO_8601: string;
begin
  if CreateGuid(Guid) = S_OK then
  begin
    self.event_id := GUID4ToString(Guid);
  end;
  self.event_timestamp := formatdatetime('yyyy/mm/dd', time) + 'T' +
    formatdatetime('hh:nn:ss', time);
end;

function BaseEvent.tagsToJson(tags: TDictionary<string, string>): string;
var
  key, tagsJson: string;
begin
  tagsJson := 'tags:{';
  for key in tags.Keys do
  begin
    tagsJson := tagsJson + key + ':"' + tags.Items[key] + '",';
  end;
  Result := tagsJson.Remove(tagsJson.Length - 1) + '}';
end;

function BaseEvent.extraToJson(extra: TDictionary<string, string>): string;
var
  key, extraJson: string;
begin
  extraJson := 'extra:{';
  for key in extra.Keys do
  begin
    extraJson := extraJson + key + ':"' + tags.Items[key] + '",';
  end;
  Result := extraJson.Remove(extraJson.Length - 1) + '}';
end;

procedure BaseEvent.setCulprit(_culprit: string);
begin
  self.event_culprit := _culprit;
end;

procedure BaseEvent.setLevel(_level: ELevel);
begin
  self.event_level := _level;
end;

procedure BaseEvent.setLogger(_logger: string);
begin
  self.event_logger := _logger;
end;

procedure BaseEvent.setMessage(_message: string);
begin
  self.event_message := _message;
end;

procedure BaseEvent.setPlatform(_platform: string);
begin
  self.event_platform := _platform;
end;

procedure BaseEvent.setRelease(_release: string);
begin
  self.release := _release;
end;

procedure BaseEvent.setServerName(_serverName: string);
begin
  self.server_name := _serverName;
end;

function BaseEvent.ToString: string;
begin
  Result := '{ "event_id" : "' + event_id + '"' + ' ,"culprit" : "' +
    event_culprit + '"' + ' ,"timestamp" : "' + event_timestamp + '"' +
    ' ,"message" : "' + event_message + '"' + '}';
end;

{ TException }

function TException.ToString: string;
begin
  Result := '{ "event_id" : "' + event_id + '"'
  + ' ,"culprit" : "' + event_culprit + '"'
  + ' ,"timestamp" : "' + event_timestamp + '"'
  + ' ,"message" : "' + event_message + '"'
  + ',"level" : "' +GetEnumName(typeInfo(ELevel), Ord(event_level))+'"'
  + ',"exception": [{' + '"type":' + self.FException.ClassType.ClassName+',' + ',"value": "' +
    self.FException.Message + '",' + ',"module": "' + self.FException.UnitName + '"' + '}]' + '}';

end;

{ TQuery }

function TQuery.ToString: string;
begin

  Result := '{ "event_id" : "' + event_id + '"' + ' ,"culprit" : "' +
    event_culprit + '"' + ' ,"timestamp" : "' + event_timestamp + '"' +
    ' ,"message" : "' + event_message + '"' + '}';

end;

{ TMessage }

function TMessage.ToString: string;
begin
  Result := '{ "event_id" : "' + event_id + '"' + ' ,"culprit" : "' +
    event_culprit + '"' + ' ,"timestamp" : "' + event_timestamp + '"' +
    ' ,"message" : "' + event_message + '"' + '}';
end;

end.
