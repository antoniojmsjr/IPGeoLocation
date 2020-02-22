{******************************************************************************}
{                                                                              }
{           IPGeoLocation.Providers.Request                                    }
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
unit IPGeoLocation.Providers.Request;

interface

uses
  System.SysUtils, IPGeoLocation.Interfaces, REST.Client;

type

  {$REGION 'TIPGeoLocationRequestCustom'}

  TIPGeoLocationRequestCustom = class(TInterfacedObject, IIPGeoLocationRequest)
  private
    { private declarations }
    FResponse: IIPGeoLocationResponse;
    function GetEnd: IIPGeoLocationProvider;
    function GetResponse: IIPGeoLocationResponse;
    function Execute: IIPGeoLocationRequest; virtual;
    function OnResponse(const pMethod: TIPGeoLocationOnResponseEvent): IIPGeoLocationRequest;
  protected
    { protected declarations }
    [weak] //NÃO INCREMENTA O CONTADOR DE REFERÊNCIA
    FIPGeoLocationProvider: IIPGeoLocationProvider;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FIP: string;
    FProvider: string;
    FHostName: string;
    FCountryCode: string;
    FCountryCode3: string;
    FCountryName: string;
    FCountryFlag: string;
    FRegion: string;
    FCity: string;
    FZipCode: string;
    FLatitude: double;
    FLongitude: double;
    FTimeZoneOffset: string;
    FTimeZoneName: string;
    FISP: string;
    procedure InternalExecute; virtual;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string);
    destructor Destroy; override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPInfo'}

  TIPGeoLocationRequestIPInfo = class sealed sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPGeoLocation'}

  TIPGeoLocationRequestIPGeoLocation = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIP2Location'}

  TIPGeoLocationRequestIP2Location = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPAPI'}

  TIPGeoLocationRequestIPAPI = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPStack'}

  TIPGeoLocationRequestIPStack = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPIfy'}

  TIPGeoLocationRequestIPIfy = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPGeolocationAPI'}

  TIPGeoLocationRequestIPGeolocationAPI = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure InternalExecute; override;
  public
    { public declarations }
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPData'}

  TIPGeoLocationRequestIPData = class sealed(TIPGeoLocationRequestCustom)
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
  IPGeoLocation.Types, IPGeoLocation.Providers.Response, System.Net.HttpClient,
  REST.Types, System.JSON, Data.Bind.Components, Data.Bind.ObjectScope;

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

  FResponse := TIPGeoLocationProviderResponse.Create(
    FIP, FProvider, FHostName, FCountryCode, FCountryCode3, FCountryName,
    FCountryFlag, FRegion, FCity, FZipCode, FLatitude, FLongitude,
    FTimeZoneName, FTimeZoneOffset, FISP);
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

function TIPGeoLocationRequestCustom.GetEnd: IIPGeoLocationProvider;
begin
  Result := FIPGeoLocationProvider;
end;

function TIPGeoLocationRequestCustom.GetResponse: IIPGeoLocationResponse;
begin
  Result := FResponse;
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

    //RESPONSE
    FResponse := TIPGeoLocationProviderResponse.Create(
      FIP, FProvider, FHostName, FCountryCode, FCountryCode3, FCountryName,
      FCountryFlag, FRegion, FCity, FZipCode, FLatitude, FLongitude,
      FTimeZoneName, FTimeZoneOffset, FISP);
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
  if not Assigned(FRESTResponse.JSONValue) then
    raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_JSON_INVALID,
                                         FProvider, 'JSON Inválido');
end;

function TIPGeoLocationRequestCustom.OnResponse(
  const pMethod: TIPGeoLocationOnResponseEvent): IIPGeoLocationRequest;
begin
  Result := Self;
  if Assigned(pMethod) then
    pMethod(FResponse);
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
