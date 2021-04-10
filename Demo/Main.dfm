object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'IP Geolocaliza'#231#227'o'
  ClientHeight = 461
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 60
    Width = 783
    Height = 5
    Align = alTop
    Shape = bsTopLine
    ExplicitTop = 41
    ExplicitWidth = 659
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 11
      Width = 12
      Height = 13
      Caption = 'IP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 320
      Top = 11
      Width = 52
      Height = 13
      Caption = 'Provedor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel4: TBevel
      Left = 300
      Top = 5
      Width = 5
      Height = 50
      Shape = bsLeftLine
    end
    object edtIP: TEdit
      Left = 9
      Top = 30
      Width = 160
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '8.8.8.8'
    end
    object cbxProvedor: TComboBox
      Left = 320
      Top = 30
      Width = 160
      Height = 24
      Style = csDropDownList
      DropDownCount = 15
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Items.Strings = (
        ''
        'IP Info'
        'IP Geolocation'
        'IP2Location'
        'IP API'
        'IP Stack'
        'IP Ify'
        'IPGeolocationAPI'
        'IPData'
        'IPWhois'
        'IPDig'
        'IPTwist'
        'IPLabstack'
        'IP-API'
        'DB-IP')
    end
    object btnLocalizacao: TButton
      Left = 500
      Top = 29
      Width = 100
      Height = 25
      Caption = 'Localiza'#231#227'o'
      TabOrder = 2
      OnClick = btnLocalizacaoClick
    end
    object btnIPExterno: TButton
      Left = 185
      Top = 29
      Width = 100
      Height = 25
      Caption = 'IP Externo'
      TabOrder = 3
      OnClick = btnIPExternoClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 65
    Width = 783
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Bevel2: TBevel
      Left = 300
      Top = 0
      Width = 5
      Height = 396
      Align = alLeft
      Shape = bsLeftLine
      ExplicitLeft = 209
      ExplicitHeight = 453
    end
    object Bevel3: TBevel
      Left = 605
      Top = 0
      Width = 5
      Height = 396
      Align = alLeft
      Shape = bsLeftLine
      ExplicitLeft = 410
      ExplicitHeight = 383
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 396
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object mmoJSONGeolocalizacao: TMemo
        Left = 0
        Top = 0
        Width = 300
        Height = 396
        Align = alClient
        BevelInner = bvNone
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Panel4: TPanel
      Left = 305
      Top = 0
      Width = 300
      Height = 396
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object vleJSON: TValueListEditor
        Left = 0
        Top = 0
        Width = 300
        Height = 396
        Align = alClient
        BorderStyle = bsNone
        KeyOptions = [keyEdit, keyUnique]
        Strings.Strings = (
          'ip ='
          'ip_version ='
          'provider ='
          'datetime ='
          'hostname ='
          'country_code ='
          'country_code3 ='
          'country_name ='
          'country_flag ='
          'state='
          'city ='
          'district ='
          'zip_code ='
          'latitude ='
          'longitude='
          'timezone_name='
          'timezone_offset='
          'isp=')
        TabOrder = 0
        OnClick = vleJSONClick
        ExplicitLeft = -1
        ExplicitTop = 1
        ColWidths = (
          89
          209)
      end
    end
    object wbrMaps: TWebBrowser
      Left = 610
      Top = 0
      Width = 173
      Height = 396
      Align = alClient
      TabOrder = 2
      ExplicitLeft = 512
      ExplicitTop = 6
      ExplicitWidth = 124
      ControlData = {
        4C000000E1110000EE2800000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object rstClientGetIP: TRESTClient
    BaseURL = 'https://api.ipgeolocation.io/getip'
    Params = <>
    SecureProtocols = [TLS1, TLS11, TLS12]
    Left = 80
    Top = 71
  end
  object rstRequestGetIP: TRESTRequest
    Client = rstClientGetIP
    Params = <>
    Response = rstResponseGetIP
    SynchronizedEvents = False
    Left = 32
    Top = 119
  end
  object rstResponseGetIP: TRESTResponse
    Left = 120
    Top = 119
  end
end
