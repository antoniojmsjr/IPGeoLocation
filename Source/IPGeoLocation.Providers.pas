{******************************************************************************}
{                                                                              }
{           IPGeoLocation.Providers                                            }
{                                                                              }
{           Copyright (C) Antônio José Medeiros Schneider Júnior               }
{                                                                              }
{           https://github.com/antoniojmsjr/IPGeoLocation                      }
{                                                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit IPGeoLocation.Providers;

interface

uses System.SysUtils, REST.Json.Types, REST.Json, REST.Types, REST.Client,
Data.Bind.Components, Data.Bind.ObjectScope, IPGeoLocation.Types,
IPGeoLocation.Interfaces, System.JSON;

type

  {$REGION 'TIPGeoLocationProviderCustom'}

  TIPGeoLocationProviderCustom = class(TInterfacedObject, IIPGeoLocationProvider)
  strict private
    { private declarations }
    function GetID: string;
    function GetURI: string;
    function GetKey: string;
    function GetRequestAccept: string;
    function GetRequestPer: TIPGeoLocationRequestLimitPerKind;
    function GetRequestLimit: LongInt;
    function GetAvailable: TDateTime;
    function GetTimeout: Integer;
    function GetEnd: IIPGeoLocation;
  protected
    { protected declarations }
    [Weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FIPGeoLocation: IIPGeoLocation;
    FSettingsExecuted: Boolean;
    FIP: string;
    FID: string;
    FURI: string;
    FKey: string;
    FRequestAccept: string;
    FRequestPer: TIPGeoLocationRequestLimitPerKind;
    FRequestLimit: LongInt;
    FAvailable: TDateTime;
    FTimeout: Integer;
    function Settings: IIPGeoLocationProvider; virtual;
    function GetRequest: IIPGeoLocationRequest; virtual;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); overload; virtual;
    constructor Create(pParent: IIPGeoLocation; const pIP: string); overload;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestCustom'}

  TIPGeoLocationRequestCustom = class(TInterfacedObject, IIPGeoLocationRequest)
  private
    { private declarations }
    function GetIP: string;
    function GetProvider: string;
    function GetHostName: string;
    function GetCountryCode: string;
    function GetCountryCode3: string;
    function GetCountryName: string;
    function GetCountryFlag: string;
    function GetRegion: string;
    function GetCity: string;
    function GetZipCode: string;
    function GetLatitude: double;
    function GetLongitude: double;
    function GetTimeZoneName: string;
    function GetTimeZoneOffset: string;
    function GetISP: string;
    function GetEnd: IIPGeoLocationProvider;
    function Execute: IIPGeoLocationRequest; virtual;
    function ToJSON(pResult: TEventIPGeoLocationResultString): IIPGeoLocationRequest;
  protected
    { protected declarations }
    [weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    [JSONMarshalled(False)]
    FIPGeoLocationProvider: IIPGeoLocationProvider;
    [JSONMarshalled(False)]
    FRESTClient: TRESTClient;
    [JSONMarshalled(False)]
    FRESTRequest: TRESTRequest;
    [JSONMarshalled(False)]
    FRESTResponse: TRESTResponse;
    [JsonName('ip')]
    FIP: string;
    [JsonName('provider')]
    FProvider: string;
    [JsonName('hostname')]
    FHostName: string;
    [JsonName('country_code')]
    FCountryCode: string;
    [JsonName('country_code3')]
    FCountryCode3: string;
    [JsonName('country_name')]
    FCountryName: string;
    [JsonName('country_flag')]
    FCountryFlag: string;
    [JsonName('region')]
    FRegion: string;
    [JsonName('city')]
    FCity: string;
    [JsonName('zip_code')]
    FZipCode: string;
    [JsonName('latitude')]
    FLatitude: double;
    [JsonName('longitude')]
    FLongitude: double;
    [JsonName('timezone_offset')]
    FTimeZoneOffset: string;
    [JsonName('timezone_name')]
    FTimeZoneName: string;
    [JsonName('isp')]
    FISP: string;
    procedure InternalExecute; virtual;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string);
    destructor Destroy; override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPInfo'}

  TIPGeoLocationProviderIPInfo = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPInfo'}

  TIPGeoLocationRequestIPInfo = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPGeoLocation'}

  TIPGeoLocationProviderIPGeoLocation = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPGeoLocation'}

  TIPGeoLocationRequestIPGeoLocation = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIP2Location'}

  TIPGeoLocationProviderIP2Location = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIP2Location'}

  TIPGeoLocationRequestIP2Location = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPAPI'}

  TIPGeoLocationProviderIPAPI = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPAPI'}

  TIPGeoLocationRequestIPAPI = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPStack'}

  TIPGeoLocationProviderIPStack = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPStack'}

  TIPGeoLocationRequestIPStack = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPIfy'}

  TIPGeoLocationProviderIPIfy = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPIfy'}

  TIPGeoLocationRequestIPIfy = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}

  TIPGeoLocationProviderIPGeolocationAPI = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPGeolocationAPI'}

  TIPGeoLocationRequestIPGeolocationAPI = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPData'}

  TIPGeoLocationProviderIPData = class(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function Settings: IIPGeoLocationProvider; override;
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPData'}

  TIPGeoLocationRequestIPData = class(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

implementation

uses
  System.Net.HttpClient;

{$REGION 'TIPGeoLocationProviderCustom'}

constructor TIPGeoLocationProviderCustom.Create(pParent: IIPGeoLocation);
begin
  FIPGeoLocation := pParent;
end;

constructor TIPGeoLocationProviderCustom.Create(pParent: IIPGeoLocation; const pIP: string);
begin
  Create(pParent);
  FIP := pIP;
end;

function TIPGeoLocationProviderCustom.Settings: IIPGeoLocationProvider;
begin
  Result := Self;

  FSettingsExecuted := False;
  FURI := EmptyStr;
  FKey := EmptyStr;
  FRequestAccept := EmptyStr;
  FRequestPer := TIPGeoLocationRequestLimitPerKind.iglPer_UNKNOWN;
  FRequestLimit := 0;
  FTimeout := 30000;
  FAvailable := 0;
end;

function TIPGeoLocationProviderCustom.GetRequest: IIPGeoLocationRequest;
begin
  if not FSettingsExecuted then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_PARAMS_NOT_FOUND,
      FID, 'Configuração não informada.');
end;

function TIPGeoLocationProviderCustom.GetEnd: IIPGeoLocation;
begin
  Result := FIPGeoLocation;
end;

function TIPGeoLocationProviderCustom.GetID: string;
begin
  Result := FID;
end;

function TIPGeoLocationProviderCustom.GetRequestAccept: string;
begin
  Result := FRequestAccept;
end;

function TIPGeoLocationProviderCustom.GetAvailable: TDateTime;
begin
  Result := FAvailable;
end;

function TIPGeoLocationProviderCustom.GetKey: string;
begin
  Result := FKey;
end;

function TIPGeoLocationProviderCustom.GetRequestLimit: LongInt;
begin
  Result := FRequestLimit;
end;

function TIPGeoLocationProviderCustom.GetRequestPer: TIPGeoLocationRequestLimitPerKind;
begin
  Result := FRequestPer;
end;

function TIPGeoLocationProviderCustom.GetTimeout: Integer;
begin
  Result := FTimeout;
end;

function TIPGeoLocationProviderCustom.GetURI: string;
begin
  Result := FURI;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestCustom'}

constructor TIPGeoLocationRequestCustom.Create(pParent: IIPGeoLocationProvider; const pIP: string);
begin
  FIPGeoLocationProvider := pParent;
  FIP := pIP;

  //IDENTIFICAÇÃO DO PROVEDOR
  FProvider := FIPGeoLocationProvider.ID;

  FRESTClient   := TRESTClient.Create(nil);
  FRESTRequest  := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);
  FRESTRequest.Client   := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
end;

destructor TIPGeoLocationRequestCustom.Destroy;
begin
  FRESTRequest.Client := nil;
  FRESTRequest.Response := nil;
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
  inherited Destroy;
end;

function TIPGeoLocationRequestCustom.Execute: IIPGeoLocationRequest;
begin
  Result := Self;

  //RESET
  FHostName       := EmptyStr;
  FCountryCode    := EmptyStr;
  FCountryCode3   := EmptyStr;
  FCountryName    := EmptyStr;
  FCountryFlag    := EmptyStr;
  FRegion         := EmptyStr;
  FCity           := EmptyStr;
  FZipCode        := EmptyStr;
  FLatitude       := 0.00;
  FLongitude      := 0.00;
  FTimeZoneOffset := EmptyStr;
  FTimeZoneName   := EmptyStr;
  FISP            := EmptyStr;

  FRESTClient.ResetToDefaults;
  FRESTRequest.ResetToDefaults;
  FRESTResponse.ResetToDefaults;

  FRESTRequest.Timeout := FIPGeoLocationProvider.Timeout;

  try

    //REQUEST
    InternalExecute;

  except
    on E: EIPGeoLocationException do
    begin
      raise EIPGeoLocationRequestException.Create(E.Kind, E.Provider,
        FRESTClient.BaseURL,
        FRESTResponse.StatusCode,
        FRESTResponse.StatusText,
        RESTRequestMethodToString(FRESTRequest.Method),
        E.Message);
    end;
    on E: Exception do
    begin
      raise EIPGeoLocationRequestException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_UNKNOWN,
        FProvider,
        FRESTClient.BaseURL,
        FRESTResponse.StatusCode,
        FRESTResponse.StatusText,
        RESTRequestMethodToString(FRESTRequest.Method),
        E.Message);
    end;
  end;
end;

procedure TIPGeoLocationRequestCustom.InternalExecute;
begin
  //REQUISIÇÃO
  try
    FRESTRequest.Execute();
  except
    on E: ENetHTTPClientException do
    begin
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_HTTP,
                                           FProvider, E.Message);
    end;
    on E: Exception do
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_UNKNOWN,
                                           FProvider, E.Message);
  end;


  //RESPOSTA COM CONTEÚDO?
  if FRESTResponse.Content.Trim.IsEmpty then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_NO_CONTENT,
                                         FProvider, 'Conteúdo vazio');

  //CÓDIGO DE RETORNO DO SERVIDOR
  if (FRESTResponse.StatusCode <> 200) then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                         FProvider, FRESTResponse.Content);

  //VERIFICAÇÃO DO RETORNO DO JSON
  if not Assigned( FRESTResponse.JSONValue ) then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_JSON_INVALID,
                                         FProvider, 'JSON Inválido');
end;

function TIPGeoLocationRequestCustom.ToJSON(pResult: TEventIPGeoLocationResultString): IIPGeoLocationRequest;
var
  lJSONObject: TJSONObject;
begin
  Result := Self;

  lJSONObject := TJson.ObjectToJsonObject(Self, [TJsonOption.joDateFormatISO8601]);

  try
    if Assigned(pResult) then
      pResult(lJSONObject.ToString);
  finally
    if Assigned(lJSONObject) then
      FreeAndNil(lJSONObject);
  end;
end;

function TIPGeoLocationRequestCustom.GetEnd: IIPGeoLocationProvider;
begin
  Result := FIPGeoLocationProvider;
end;

function TIPGeoLocationRequestCustom.GetCity: string;
begin
  Result := FCity;
end;

function TIPGeoLocationRequestCustom.GetCountryCode: string;
begin
  Result := FCountryCode;
end;

function TIPGeoLocationRequestCustom.GetCountryCode3: string;
begin
  Result := FCountryCode3;
end;

function TIPGeoLocationRequestCustom.GetCountryFlag: string;
begin
  Result := FCountryFlag;
end;

function TIPGeoLocationRequestCustom.GetCountryName: string;
begin
  Result := FCountryName;
end;

function TIPGeoLocationRequestCustom.GetHostName: string;
begin
  Result := FHostName;
end;

function TIPGeoLocationRequestCustom.GetIP: string;
begin
  Result := FIP;
end;

function TIPGeoLocationRequestCustom.GetISP: string;
begin
  Result := FISP;
end;

function TIPGeoLocationRequestCustom.GetLatitude: double;
begin
  Result := FLatitude;
end;

function TIPGeoLocationRequestCustom.GetLongitude: double;
begin
  Result := FLongitude;
end;

function TIPGeoLocationRequestCustom.GetProvider: string;
begin
  Result := FProvider;
end;

function TIPGeoLocationRequestCustom.GetRegion: string;
begin
  Result := FRegion;
end;

function TIPGeoLocationRequestCustom.GetTimeZoneName: string;
begin
  Result := FTimeZoneName;
end;

function TIPGeoLocationRequestCustom.GetTimeZoneOffset: string;
begin
  Result := FTimeZoneOffset;
end;

function TIPGeoLocationRequestCustom.GetZipCode: string;
begin
  Result := FZipCode;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPInfo'}

constructor TIPGeoLocationProviderIPInfo.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPINFO';
end;

function TIPGeoLocationProviderIPInfo.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPInfo.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPInfo.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'https://ipinfo.io';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_month;
  FRequestLimit   := 50000;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPInfo'}

procedure TIPGeoLocationRequestIPInfo.InternalExecute;
var
  lJSONObject: TJSONObject;
  lCoordinates: string;
  lCoordinatesArray: TArray<string>;
  lFormatSettings: TFormatSettings;
begin

  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := '{IP}';
  FRESTRequest.Params.AddHeader('Authorization',
                                Format('%s %s', ['Bearer', FIPGeoLocationProvider.Key]));

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'IP';
  FRESTRequest.Params.Items[0].Value  := FIP;
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkURLSEGMENT;

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      lJSONObject.TryGetValue('hostname', FHostName);
      lJSONObject.TryGetValue('city', FCity);
      lJSONObject.TryGetValue('region', FRegion);
      lJSONObject.TryGetValue('country', FCountryCode);
      lJSONObject.TryGetValue('loc', lCoordinates);
      lJSONObject.TryGetValue('org', FISP);
      lJSONObject.TryGetValue('postal', FZipCode);
      lJSONObject.TryGetValue('timezone', FTimeZoneName);

      lCoordinatesArray := lCoordinates.Split([',']);
      if (Length(lCoordinatesArray) >= 2) then
      begin
        lFormatSettings := TFormatSettings.Create('en-US');
        TryStrToFloat(lCoordinatesArray[0], FLatitude, lFormatSettings);
        TryStrToFloat(lCoordinatesArray[1], FLongitude, lFormatSettings);
      end;
    end;
  end;

end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPGeoLocation'}
constructor TIPGeoLocationProviderIPGeoLocation.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPGEOLOCATION';
end;

function TIPGeoLocationProviderIPGeoLocation.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPGeoLocation.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPGeoLocation.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'https://api.ipgeolocation.io/ipgeo';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 30000;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPGeoLocation'}

procedure TIPGeoLocationRequestIPGeoLocation.InternalExecute;
var
  lJSONObject: TJSONObject;
begin

  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Method := TRESTRequestMethod.rmGET;

  //API KEY
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'apiKey'; //case-sensitive
  FRESTRequest.Params.Items[0].Value  := FIPGeoLocationProvider.Key;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[1].Name   := 'ip';
  FRESTRequest.Params.Items[1].Value  := FIP;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[1].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //LINGUAGEM
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[2].Name   := 'lang';
  FRESTRequest.Params.Items[2].Value  := 'en';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[2].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      lJSONObject.TryGetValue('hostname', FHostName);
      lJSONObject.TryGetValue('country_code2', FCountryCode);
      lJSONObject.TryGetValue('country_code3', FCountryCode3);
      lJSONObject.TryGetValue('country_name', FCountryName);
      lJSONObject.TryGetValue('country_flag', FCountryFlag);
      lJSONObject.TryGetValue('state_prov', FRegion);
      lJSONObject.TryGetValue('city', FCity);
      lJSONObject.TryGetValue('zipcode', FZipCode);
      lJSONObject.TryGetValue('isp', FISP);
      lJSONObject.TryGetValue('latitude', FLatitude);
      lJSONObject.TryGetValue('longitude', FLongitude);

      //TIMEZONE
      lJSONObject.GetValue('time_zone').TryGetValue('name', FTimeZoneName);
      lJSONObject.GetValue('time_zone').TryGetValue('offset', FTimeZoneOffset);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIP2Location'}

constructor TIPGeoLocationProviderIP2Location.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IP2LOCATION';
end;

function TIPGeoLocationProviderIP2Location.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIP2Location.Create(Self, FIP);
end;

function TIPGeoLocationProviderIP2Location.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'https://api.ip2location.com/v2/';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Day;
  FRequestLimit   := 200;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIP2Location'}

procedure TIPGeoLocationRequestIP2Location.InternalExecute;
var
  lJSONObject: TJSONObject;
begin

  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Method := TRESTRequestMethod.rmGET;

  //KEY API
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'key';
  FRESTRequest.Params.Items[0].Value  := FIPGeoLocationProvider.Key;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[1].Name   := 'ip';
  FRESTRequest.Params.Items[1].Value  := FIP;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[1].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //CONFIGURAÇÕES EXTRAS - DOCUMENTAÇÃO
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[2].Name   := 'package';
  FRESTRequest.Params.Items[2].Value  := 'WS24';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[2].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //CONFIGURAÇÕES EXTRAS - DOCUMENTAÇÃO
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[3].Name   := 'addon';
  FRESTRequest.Params.Items[3].Value  := 'country,time_zone_info';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[3].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      //CONFORME A DOCUMENTAÇÃO DA API
      if Assigned(lJSONObject.GetValue('response')) then
      begin
        raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                             FProvider, lJSONObject.GetValue('response').Value);
      end;

      lJSONObject.TryGetValue('country_code', FCountryCode);
      lJSONObject.GetValue('country').TryGetValue('alpha3_code', FCountryCode3);
      lJSONObject.GetValue('country').TryGetValue('flag', FCountryFlag);
      lJSONObject.GetValue('country').TryGetValue('name', FCountryName);
      lJSONObject.TryGetValue('region_name', FRegion);
      lJSONObject.TryGetValue('city_name', FCity);
      lJSONObject.TryGetValue('zip_code', FZipCode);
      lJSONObject.TryGetValue('isp', FISP);
      lJSONObject.TryGetValue('latitude', FLatitude);
      lJSONObject.TryGetValue('longitude', FLongitude);

      //TIMEZONE
      lJSONObject.TryGetValue('time_zone', FTimeZoneOffset);
      lJSONObject.GetValue('time_zone_info').TryGetValue('olson', FTimeZoneName);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPAPI'}

constructor TIPGeoLocationProviderIPAPI.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPAPI';
end;

function TIPGeoLocationProviderIPAPI.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPAPI.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPAPI.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'http://api.ipapi.com/api/';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPAPI'}

procedure TIPGeoLocationRequestIPAPI.InternalExecute;
var
  lJSONObject: TJSONObject;
  lRequestSuccessAPI: Boolean;
begin

  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Method := TRESTRequestMethod.rmGET;

  //URLSEGMENT
  FRESTRequest.Resource := '{ip}';

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'ip';
  FRESTRequest.Params.Items[0].Value  := FIP;
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkURLSEGMENT;

  //KEY API
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[1].Name   := 'access_key';
  FRESTRequest.Params.Items[1].Value  := FIPGeoLocationProvider.Key;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[1].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //FORMATO DE SAÍDA
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[2].Name   := 'output';
  FRESTRequest.Params.Items[2].Value  := 'json';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[2].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //LINGUAGEM DE SAÍDA
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[3].Name   := 'language';
  FRESTRequest.Params.Items[3].Value  := 'pt-br';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[3].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[4].Name   := 'hostname';
  FRESTRequest.Params.Items[4].Value  := '1';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[4].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      //CONFORME A DOCUMENTAÇÃO DA API
      lJSONObject.TryGetValue('success', lRequestSuccessAPI);
      if (lRequestSuccessAPI = False) then
      begin
        if Assigned(lJSONObject.GetValue('error')) then
          raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                               FProvider, lJSONObject.GetValue('error').ToString);
      end;

      lJSONObject.TryGetValue('hostname', FHostName);
      lJSONObject.TryGetValue('country_code', FCountryCode);
      lJSONObject.GetValue('location').TryGetValue('country_flag', FCountryFlag);
      lJSONObject.TryGetValue('country_name', FCountryName);
      lJSONObject.TryGetValue('region_name', FRegion);
      lJSONObject.TryGetValue('city', FCity);
      lJSONObject.TryGetValue('zip', FZipCode);
      lJSONObject.TryGetValue('isp', FISP);
      lJSONObject.TryGetValue('latitude', FLatitude);
      lJSONObject.TryGetValue('longitude', FLongitude);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPStack'}

constructor TIPGeoLocationProviderIPStack.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPSTACK';
end;

function TIPGeoLocationProviderIPStack.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPStack.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPStack.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'http://api.ipstack.com/';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPStack'}

procedure TIPGeoLocationRequestIPStack.InternalExecute;
var
  lJSONObject: TJSONObject;
  lRequestSuccessAPI: Boolean;
begin
  lRequestSuccessAPI := True;

  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := '{ip}';

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'ip';
  FRESTRequest.Params.Items[0].Value  := FIP;
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkURLSEGMENT;

  //KEY API
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[1].Name   := 'access_key';
  FRESTRequest.Params.Items[1].Value  := FIPGeoLocationProvider.Key;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[1].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //FORMATO DE SAÍDA
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[2].Name   := 'output';
  FRESTRequest.Params.Items[2].Value  := 'json';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[2].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //LINGUAGEM DE SAÍDA
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[3].Name   := 'language';
  FRESTRequest.Params.Items[3].Value  := 'pt-br';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[3].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[4].Name   := 'hostname';
  FRESTRequest.Params.Items[4].Value  := '1';
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[4].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      //CONFORME A DOCUMENTAÇÃO DA API
      lJSONObject.TryGetValue('success', lRequestSuccessAPI);
      if (lRequestSuccessAPI = False) then
      begin
        if Assigned(lJSONObject.GetValue('error')) then
          raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                               FProvider, lJSONObject.GetValue('error').ToString);
      end;

      lJSONObject.TryGetValue('hostname', FHostName);
      lJSONObject.TryGetValue('country_code', FCountryCode);
      lJSONObject.GetValue('location').TryGetValue('country_flag', FCountryFlag);
      lJSONObject.TryGetValue('country_name', FCountryName);
      lJSONObject.TryGetValue('region_name', FRegion);
      lJSONObject.TryGetValue('city', FCity);
      lJSONObject.TryGetValue('zip', FZipCode);
      lJSONObject.TryGetValue('isp', FISP);
      lJSONObject.TryGetValue('latitude', FLatitude);
      lJSONObject.TryGetValue('longitude', FLongitude);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPIfy'}

constructor TIPGeoLocationProviderIPIfy.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPIFY';
end;

function TIPGeoLocationProviderIPIfy.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPIfy.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPIfy.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'https://geo.ipify.org/api/v1/';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPIfy'}

procedure TIPGeoLocationRequestIPIfy.InternalExecute;
var
  lJSONObject: TJSONObject;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Method := TRESTRequestMethod.rmGET;

  //KEY API
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'apiKey';
  FRESTRequest.Params.Items[0].Value  := FIPGeoLocationProvider.Key;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[1].Name   := 'ipAddress';
  FRESTRequest.Params.Items[1].Value  := FIP;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[1].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      lJSONObject.GetValue('location').TryGetValue('country', FCountryCode);
      lJSONObject.GetValue('location').TryGetValue('region', FRegion);
      lJSONObject.GetValue('location').TryGetValue('city', FCity);
      lJSONObject.GetValue('location').TryGetValue('lat', FLatitude);
      lJSONObject.GetValue('location').TryGetValue('lng', FLongitude);
      lJSONObject.GetValue('location').TryGetValue('postalCode', FZipCode);
      lJSONObject.GetValue('location').TryGetValue('timezone', FTimeZoneOffset);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}

constructor TIPGeoLocationProviderIPGeolocationAPI.Create(
  pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPGEOLOCATIONAPI';
end;

function TIPGeoLocationProviderIPGeolocationAPI.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPGeolocationAPI.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPGeolocationAPI.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'https://api.ipgeolocationapi.com/geolocate';
  FKey            := EmptyStr; //FULL FREE
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Free;
  FRequestLimit   := 0;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPGeolocationAPI'}

procedure TIPGeoLocationRequestIPGeolocationAPI.InternalExecute;
var
  lJSONObject: TJSONObject;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Resource := '{IP}';
  FRESTRequest.Method := TRESTRequestMethod.rmGET;

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'IP';
  FRESTRequest.Params.Items[0].Value  := FIP;
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkURLSEGMENT;

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      lJSONObject.TryGetValue('alpha2', FCountryCode);
      lJSONObject.TryGetValue('alpha3', FCountryCode3);
      lJSONObject.GetValue('geo').TryGetValue('latitude', FLatitude);
      lJSONObject.GetValue('geo').TryGetValue('longitude', FLongitude);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPData'}

constructor TIPGeoLocationProviderIPData.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPDATA';
end;

function TIPGeoLocationProviderIPData.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPData.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPData.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI            := 'https://api.ipdata.co';
  FKey            := 'TOKEN';
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Day;
  FRequestLimit   := 1500;
  FAvailable      := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPData'}

procedure TIPGeoLocationRequestIPData.InternalExecute;
var
  lJSONObject: TJSONObject;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  FRESTClient.BaseURL := FIPGeoLocationProvider.URI;
  FRESTClient.Accept  := FIPGeoLocationProvider.RequestAccept;

  FRESTRequest.Resource := '{IP}';
  FRESTRequest.Method := TRESTRequestMethod.rmGET;

  //IP
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[0].Name   := 'IP';
  FRESTRequest.Params.Items[0].Value  := FIP;
  FRESTRequest.Params.Items[0].Kind   := TRESTRequestParameterKind.pkURLSEGMENT;

  //API Key
  FRESTRequest.Params.AddItem;
  FRESTRequest.Params.Items[1].Name   := 'api-key';
  FRESTRequest.Params.Items[1].Value  := FIPGeoLocationProvider.Key;
  {$IF CompilerVersion > 32}
  FRESTRequest.Params.Items[1].Kind   := TRESTRequestParameterKind.pkQUERY;
  {$IFEND}

  //REQUISIÇÃO
  inherited;

  //CONFORME A DOCUMENTAÇÃO DA API
  case FRESTResponse.StatusCode of
    200:
    begin
      lJSONObject := FRESTResponse.JSONValue as TJSONObject;

      lJSONObject.TryGetValue('country_code', FCountryCode);
      lJSONObject.TryGetValue('flag', FCountryFlag);
      lJSONObject.TryGetValue('country_name', FCountryName);
      lJSONObject.TryGetValue('region', FRegion);
      lJSONObject.TryGetValue('city', FCity);
      lJSONObject.TryGetValue('postal', FZipCode);
      lJSONObject.TryGetValue('latitude', FLatitude);
      lJSONObject.TryGetValue('longitude', FLongitude);
      lJSONObject.GetValue('asn').TryGetValue('name', FISP);
      lJSONObject.GetValue('time_zone').TryGetValue('offset', FTimeZoneOffset);
      lJSONObject.GetValue('time_zone').TryGetValue('name', FTimeZoneName);
    end;
  end;
end;

{$ENDREGION}

end.
