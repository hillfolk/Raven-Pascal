object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'RavenOfDelphi'
  ClientHeight = 452
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object tmrLabel: TLabel
    Left = 626
    Top = 8
    Width = 3
    Height = 13
    Alignment = taCenter
    Color = clBtnFace
    ParentColor = False
  end
  object LogBox: TMemo
    Left = 24
    Top = 320
    Width = 481
    Height = 113
    TabOrder = 0
  end
  object Button1: TButton
    Left = 520
    Top = 320
    Width = 201
    Height = 49
    Caption = 'Exceute'
    TabOrder = 1
    OnClick = Button1Click
  end
  object rgHttpMethod: TRadioGroup
    Left = 8
    Top = 0
    Width = 121
    Height = 41
    Caption = 'Http Method'
    ItemIndex = 0
    Items.Strings = (
      'POST'
      'GET')
    TabOrder = 2
  end
  object edtAURL: TEdit
    Left = 135
    Top = 8
    Width = 474
    Height = 21
    TabOrder = 3
    Text = 
      'http://2287716fddd94b16b5cf19c49b05fb35:5a52c3092b4742ce9532f32b' +
      'fad285dc@sentry.hillfolk.org:32779/api/2/store/'
  end
  object parmeterGroup: TGroupBox
    Left = 8
    Top = 47
    Width = 713
    Height = 258
    Caption = 'Sentry Parameter'
    Color = cl3DLight
    ParentBackground = False
    ParentColor = False
    TabOrder = 4
    object Label1: TLabel
      Left = 200
      Top = 27
      Width = 22
      Height = 13
      Caption = 'type'
    end
    object edtCulpri: TLabel
      Left = 8
      Top = 54
      Width = 29
      Height = 13
      Caption = 'culprit'
    end
    object Label3: TLabel
      Left = 8
      Top = 102
      Width = 49
      Height = 13
      Caption = 'timestamp'
    end
    object Label4: TLabel
      Left = 8
      Top = 142
      Width = 42
      Height = 13
      Caption = 'message'
    end
    object Label5: TLabel
      Left = 8
      Top = 190
      Width = 21
      Height = 13
      Caption = 'tags'
    end
    object Label6: TLabel
      Left = 8
      Top = 27
      Width = 42
      Height = 13
      Caption = 'event_id'
    end
    object Label7: TLabel
      Left = 200
      Top = 51
      Width = 26
      Height = 13
      Caption = 'value'
    end
    object Label8: TLabel
      Left = 200
      Top = 81
      Width = 34
      Height = 13
      Caption = 'module'
    end
    object edtEvent_Id: TEdit
      Left = 73
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object edtCulprit: TEdit
      Left = 73
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'my.module.function_name'
    end
    object edtTimestamp: TEdit
      Left = 73
      Top = 104
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '2011-05-02T17:41:36'
    end
    object edtMessage: TEdit
      Left = 73
      Top = 139
      Width = 265
      Height = 21
      TabOrder = 3
      Text = 'SyntaxError: Wattttt!'
    end
    object edtTagKey: TEdit
      Left = 73
      Top = 184
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object edtTagValue: TEdit
      Left = 200
      Top = 184
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object edtType: TEdit
      Left = 248
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 6
      Text = 'SyntaxError'
    end
    object edtValue: TEdit
      Left = 248
      Top = 51
      Width = 121
      Height = 21
      TabOrder = 7
      Text = 'Wattttt'
    end
    object edtModule: TEdit
      Left = 248
      Top = 78
      Width = 121
      Height = 21
      TabOrder = 8
      Text = '__builtins__'
    end
    object Button2: TButton
      Left = 635
      Top = 22
      Width = 75
      Height = 25
      Caption = 'event_id'
      TabOrder = 9
      OnClick = Button2Click
    end
  end
  object Edit1: TEdit
    Left = 423
    Top = 71
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'Edit1'
  end
  object Button3: TButton
    Left = 520
    Top = 384
    Width = 201
    Height = 49
    Caption = 'Exception'
    TabOrder = 6
    OnClick = Button3Click
  end
  object IdHTTP: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.ContentType = 'application/json'
    Request.Accept = 
      'application/json,text/html,application/xhtml+xml,application/xml' +
      ';q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'raven-python/1.0'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 672
    Top = 256
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 616
    Top = 255
  end
  object RavenClient1: TRavenClient
    PROTOCOL = 'http'
    HOST = 'app.getsentry.com'
    PORT = 80
    SENTRY_VERSION = '7'
    PROJECT_ID = 67942
    PUBLIC_KEY = 'f273091f96ef44bd9e5366f0fa935e28'
    SECRET_KEY = '236c3cab7336475c895abaa9b26af612'
    OnSend = RavenClient1Send
    Left = 560
    Top = 263
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 672
    Top = 215
  end
end
