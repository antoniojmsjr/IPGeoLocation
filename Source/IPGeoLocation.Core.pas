{******************************************************************************}
{                                                                              }
{           IPGeoLocation                                                      }
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
unit IPGeoLocation.Core;

interface

uses
  IPGeoLocation.Interfaces, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, REST.JSon.Types;

type

  {$REGION 'TIPGeoLocationProviderCustom'}
  TIPGeoLocationProviderCustom = class(TInterfacedObject, IIPGeoLocationProvider)
  strict private
    { private declarations }
    function GetID: string;
    function GetURL: string;
    function GetAPIKey: string;
    function GetTimeout: Integer;
    function SetAPIKey(const pAPIKey: string): IIPGeoLocationProvider;
    function SetTimeout(const pTimeout: Integer): IIPGeoLocationProvider;
  protected
    { protected declarations }
    [Weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FIPGeoLocation: IIPGeoLocation;
    FIP: string;
    FID: string;
    FURL: string;
    FAPIKey: string;
    FTimeout: Integer;
    function GetRequest: IIPGeoLocationRequest; virtual; abstract;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation; const pIP: string); virtual;
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationResponseCustom'}
  TIPGeoLocationResponseCustom = class(TInterfacedObject, IGeoLocation)
  private
    { private declarations }
    function GetIP: string;
    function GetProvider: string;
    function GetHostName: string;
    function GetDateTime: TDateTime;
    function GetCountryCode: string;
    function GetCountryCode3: string;
    function GetCountryName: string;
    function GetCountryFlag: string;
    function GetState: string;
    function GetCity: string;
    function GetDistrict: string;
    function GetZipCode: string;
    function GetLatitude: Extended;
    function GetLongitude: Extended;
    function GetTimeZoneName: string;
    function GetTimeZoneOffset: string;
    function GetISP: string;
    function ToJSON: string;
  protected
    { protected declarations }
    [JsonName('ip')]
    FIP: string;
    [JsonName('provider')]
    FProvider: string;
    [JsonName('datetime')]
    FDateTime: TDateTime;
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
    [JsonName('state')]
    FState: string;
    [JsonName('city')]
    FCity: string;
    [JsonName('district')]
    FDistrict: string;
    [JsonName('zip_code')]
    FZipCode: string;
    [JsonName('latitude')]
    FLatitude: Extended;
    [JsonName('longitude')]
    FLongitude: Extended;
    [JsonName('timezone_name')]
    FTimeZoneName: string;
    [JsonName('timezone_offset')]
    FTimeZoneOffset: string;
    [JsonName('isp')]
    FISP: string;
    [JSONMarshalled(False)]
    FJSON: string;
    procedure Parse; virtual; abstract;
  public
    { public declarations }
    constructor Create(const pJSON: string; const pIP: string; const pProvider: string); virtual;
    procedure AfterConstruction; override;
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestCustom'}
  TIPGeoLocationRequestCustom = class(TInterfacedObject, IIPGeoLocationRequest)
  private
    { private declarations }
    function Execute: IGeoLocation;
    function SetResultLanguageCode(const pLanguageCode: string): IIPGeoLocationRequest;
    procedure JSONValueIsValid(pJSON: string);
  protected
    { protected declarations }
    [weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FIPGeoLocationProvider: IIPGeoLocationProvider;
    FIP: string;
    FProvider: string;
    FResponseLanguageCode: string;
    FRequestHeaders: TNetHeaders;
    FHttpRequest: TNetHTTPRequest;
    FHttpClient: TNetHTTPClient;
    FCheckJSONValue: Boolean;
    function InternalExecute: IHTTPResponse; virtual;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IGeoLocation; virtual; abstract;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string); virtual;
    destructor Destroy; override;
  end;
  {$ENDREGION}

implementation

uses
  System.SysUtils, System.JSON, REST.Json, IPGeoLocation.Types;

{$REGION 'TIPGeoLocationProviderCustom'}
constructor TIPGeoLocationProviderCustom.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  FIPGeoLocation := pParent;
  FIP := pIP;
  FID := EmptyStr;
  FURL := EmptyStr;
  FAPIKey := EmptyStr;
  FTimeout := 10000;
end;

function TIPGeoLocationProviderCustom.GetAPIKey: string;
begin
  Result := FAPIKey;
end;

function TIPGeoLocationProviderCustom.GetID: string;
begin
  Result := FID;
end;

function TIPGeoLocationProviderCustom.GetTimeout: Integer;
begin
  Result := FTimeout;
end;

function TIPGeoLocationProviderCustom.GetURL: string;
begin
  Result := FURL;
end;

function TIPGeoLocationProviderCustom.SetAPIKey(
  const pAPIKey: string): IIPGeoLocationProvider;
begin
  Result := Self;
  FAPIKey := pAPIKey.Trim;
end;

function TIPGeoLocationProviderCustom.SetTimeout(
  const pTimeout: Integer): IIPGeoLocationProvider;
begin
  Result := Self;
  FTimeout := pTimeout;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseCustom'}
constructor TIPGeoLocationResponseCustom.Create(const pJSON: string;
 const pIP: string; const pProvider: string);
begin
  FJSON := pJSON;
  FIP := pIP;
  FProvider := pProvider;
  FDateTime := Now();
end;

procedure TIPGeoLocationResponseCustom.AfterConstruction;
begin
  inherited;
  Parse;
end;

function TIPGeoLocationResponseCustom.GetCity: string;
begin
  Result := FCity;
end;

function TIPGeoLocationResponseCustom.GetCountryCode: string;
begin
  Result := FCountryCode;
end;

function TIPGeoLocationResponseCustom.GetCountryCode3: string;
begin
  Result := FCountryCode3;
end;

function TIPGeoLocationResponseCustom.GetCountryFlag: string;
begin
  Result := FCountryFlag;
end;

function TIPGeoLocationResponseCustom.GetCountryName: string;
begin
  Result := FCountryName;
end;

function TIPGeoLocationResponseCustom.GetDateTime: TDateTime;
begin
  Result := FDateTime;
end;

function TIPGeoLocationResponseCustom.GetDistrict: string;
begin
  Result := FDistrict;
end;

function TIPGeoLocationResponseCustom.GetHostName: string;
begin
  Result := FHostName;
end;

function TIPGeoLocationResponseCustom.GetIP: string;
begin
  Result := FIP;
end;

function TIPGeoLocationResponseCustom.GetISP: string;
begin
  Result := FISP;
end;

function TIPGeoLocationResponseCustom.GetLatitude: Extended;
begin
  Result := FLatitude;
end;

function TIPGeoLocationResponseCustom.GetLongitude: Extended;
begin
  Result := FLongitude;
end;

function TIPGeoLocationResponseCustom.GetProvider: string;
begin
  Result := FProvider;
end;

function TIPGeoLocationResponseCustom.GetState: string;
begin
  Result := FState;
end;

function TIPGeoLocationResponseCustom.GetTimeZoneName: string;
begin
  Result := FTimeZoneName;
end;

function TIPGeoLocationResponseCustom.GetTimeZoneOffset: string;
begin
  Result := FTimeZoneOffset;
end;

function TIPGeoLocationResponseCustom.GetZipCode: string;
begin
  Result := FZipCode;
end;

function TIPGeoLocationResponseCustom.ToJSON: string;
var
  lJSONObject: TJSONObject;
begin
  Result := EmptyStr;

  lJSONObject := TJson.ObjectToJsonObject(Self, [TJsonOption.joDateFormatISO8601]);
  try
    Result := lJSONObject.ToJSON;
  finally
    if Assigned(lJSONObject) then
      FreeAndNil(lJSONObject);
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestCustom'}
constructor TIPGeoLocationRequestCustom.Create(pParent: IIPGeoLocationProvider;
  const pIP: string);
begin
  FIPGeoLocationProvider := pParent;
  FIP := pIP;
  FProvider := FIPGeoLocationProvider.ID;
  FCheckJSONValue := True;

  FHttpClient := TNetHTTPClient.Create(nil);
  FHttpRequest := TNetHTTPRequest.Create(nil);
  FHttpRequest.Client := FHttpClient;
end;

destructor TIPGeoLocationRequestCustom.Destroy;
begin
  FHttpRequest.Client := nil;
  FHttpRequest.Free;
  FHttpClient.Free;
  inherited Destroy;
end;

function TIPGeoLocationRequestCustom.Execute: IGeoLocation;
var
  lIHTTPResponse: IHTTPResponse;
  lStatusCode: Integer;
  lStatusText: String;
begin
  lStatusCode := 0;
  lStatusText := EmptyStr;

  //PARAMS
  FHttpRequest.ConnectionTimeout := FIPGeoLocationProvider.Timeout;
  FHttpRequest.ResponseTimeout := FIPGeoLocationProvider.Timeout;
  FHttpRequest.MethodString := 'GET';
  FHttpRequest.Client.Accept := 'application/json';
  FHttpRequest.Client.UserAgent := 'IPGeoLocation';

  try
    //REQUEST
    lIHTTPResponse := InternalExecute();

    if (lIHTTPResponse.StatusCode = 200) then
      Result := GetResponse(lIHTTPResponse);
  except
    on E: EIPGeoLocationException do
    begin
      if Assigned(lIHTTPResponse) then
      begin
        lStatusCode := lIHTTPResponse.StatusCode;
        lStatusText := lIHTTPResponse.StatusText;
      end;

      raise EIPGeoLocationRequestException.Create(
        E.Kind,
        E.IP,
        E.Provider,
        E.DateTime,
        FHttpRequest.URL,
        lStatusCode,
        lStatusText,
        FHttpRequest.MethodString,
        E.Message);
    end;
    on E: Exception do
    begin
      if Assigned(lIHTTPResponse) then
      begin
        lStatusCode := lIHTTPResponse.StatusCode;
        lStatusText := lIHTTPResponse.StatusText;
      end;

      raise EIPGeoLocationRequestException.Create(
        TIPGeoLocationExceptionKind.iglEXCEPTION_OTHERS,
        FIP,
        FProvider,
        Now(),
        FHttpRequest.URL,
        lStatusCode,
        lStatusText,
        FHttpRequest.MethodString,
        E.Message);
    end;
  end;
end;

function TIPGeoLocationRequestCustom.InternalExecute: IHTTPResponse;
var
  lJSON: string;
begin

  //REQUISIÇÃO
  try
    Result := FHttpRequest.Execute(FRequestHeaders);
  except
    on E: ENetHTTPClientException do
    begin
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_HTTP,
                                           FIP,
                                           FProvider,
                                           Now(),
                                           E.Message);
    end;
    on E: Exception do
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_OTHERS,
                                           FIP,
                                           FProvider,
                                           Now(),
                                           E.Message);
  end;

  //JSON
  lJSON := Result.ContentAsString.Trim;

  //RESPOSTA COM CONTEÚDO?
  if lJSON.IsEmpty then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_NO_CONTENT,
                                         FIP,
                                         FProvider,
                                         Now(),
                                         'Without content.');

  //CÓDIGO DE RETORNO DO SERVIDOR
  if (Result.StatusCode <> 200) then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                         FIP,
                                         FProvider,
                                         Now(),
                                         lJSON);

  //VERIFICAÇÃO DO RETORNO DO JSON
  JSONValueIsValid(lJSON);
end;

procedure TIPGeoLocationRequestCustom.JSONValueIsValid(pJSON: string);
var
  lJSONValue: TJSONValue;
begin
  if not FCheckJSONValue then
    Exit;

  lJSONValue := nil;
  try
    lJSONValue := TJSONObject.ParseJSONValue(pJSON);
    if not Assigned(lJSONValue) then
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_JSON_INVALID,
                                           FIP,
                                           FProvider,
                                           Now(),
                                           'JSON invalid');
  finally
    lJSONValue.Free;
  end;
end;

function TIPGeoLocationRequestCustom.SetResultLanguageCode(
  const pLanguageCode: string): IIPGeoLocationRequest;
begin
  Result := Self;
  if not pLanguageCode.Trim.IsEmpty then
    FResponseLanguageCode := pLanguageCode;
end;
{$ENDREGION}

end.
