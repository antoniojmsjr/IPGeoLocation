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
unit IPGeoLocation.Types;

interface

uses
  System.SysUtils;

type

  {$REGION 'TIPGeoLocationProviderKind'}

  {$SCOPEDENUMS ON}
  TIPGeoLocationProviderKind = (UNKNOWN,
                                IPInfo,
                                IPGeoLocation,
                                IP2Location,
                                IP2LocationIO,
                                IPApi,
                                IPStack,
                                IPIfy,
                                IPGeolocationAPI,
                                IPData,
                                IPWhois,
                                IPDig,
                                IPTwist,
                                IPLabstack,
                                IP_API,
                                DB_IP);
  {$SCOPEDENUMS OFF}

  {$ENDREGION}

  {$REGION 'TIPGeoLocationExceptionKind'}

  {$SCOPEDENUMS ON}
  TIPGeoLocationExceptionKind = (EXCEPTION_UNKNOWN,
                                 EXCEPTION_OTHERS,
                                 EXCEPTION_HTTP,
                                 EXCEPTION_PARAMS_NOT_FOUND,
                                 EXCEPTION_API,
                                 EXCEPTION_JSON_INVALID,
                                 EXCEPTION_NO_CONTENT);
  {$SCOPEDENUMS OFF}

  {$ENDREGION}

  {$REGION 'EIPGeoLocationException'}
  EIPGeoLocationException = class(Exception)
  strict private
    { private declarations }
    FKind: TIPGeoLocationExceptionKind;
    FIP: string;
    FIPVersion: string;
    FProvider: string;
    FDateTime: TDateTime;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(const pKind: TIPGeoLocationExceptionKind;
                       const pIP: string;
                       const pProvider: string;
                       const pDateTime: TDateTime;
                       const pMessage: string);
    property Kind: TIPGeoLocationExceptionKind read FKind;
    property IP: string read FIP;
    property IPVersion: string read FIPVersion;
    property Provider: string read FProvider;
    property DateTime: TDateTime read FDateTime;
  end;
  {$ENDREGION}

  {$REGION 'EIPGeoLocationRequestException'}
  EIPGeoLocationRequestException = class sealed(EIPGeoLocationException)
  strict private
    { private declarations }
    FStatusCode: Integer;
    FStatusText: string;
    FURL: string;
    FMethod: string;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(const pKind: TIPGeoLocationExceptionKind;
                       const pIP: string;
                       const pProvider: string;
                       const pDateTime: TDateTime;
                       const pURL: string;
                       const pStatusCode: Integer;
                       const pStatusText: string;
                       const pMethod: string;
                       const pMessage: string);
    property URL: string read FURL;
    property StatusCode: Integer read FStatusCode;
    property StatusText: string read FStatusText;
    property Method: string read FMethod;
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderKindHelper'}
  TIPGeoLocationProviderKindHelper = record helper for TIPGeoLocationProviderKind
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function AsString: string;
    function AsInteger: Integer;
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationExceptionKindHelper'}
  TIPGeoLocationExceptionKindHelper = record helper for TIPGeoLocationExceptionKind
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function AsString: string;
    function AsInteger: Integer;
  end;
  {$ENDREGION}

  function GetIPVersion(const pIP: string): string;

implementation

uses
  RegularExpressions;

//https://ihateregex.io/expr/ipv6
//https://www.regular-expressions.info/ip.html
function IPv4IsValid(const pIP: string): boolean;
const
  cRexIPv4 = '\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b';
begin
  Result := TRegEx.IsMatch(pIP, cRexIPv4);
end;

function IPv6IsValid(const pIP: string): boolean;
const
cRexIPv61 = '\b(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|';
cRexIPv62 = cRexIPv61 + '([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|';
cRexIPv63 = cRexIPv62 + 'fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|';
cRexIPv6 = cRexIPv63 + '(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\b';
begin
  Result := TRegEx.IsMatch(pIP, cRexIPv6);
end;

function GetIPVersion(const pIP: string): string;
begin
  if IPv4IsValid(pIP) then
    Exit('IPv4')
  else
    if IPv6IsValid(pIP) then
      Exit('IPv6')
    else
      Exit('Unknown');
end;

{$REGION 'EIPGeoLocationException'}
constructor EIPGeoLocationException.Create(
  const pKind: TIPGeoLocationExceptionKind;
  const pIP: string; const pProvider: string; const pDateTime: TDateTime;
  const pMessage: string);
begin
  FKind := pKind;
  FIP := pIP;
  FIPVersion := GetIPVersion(FIP);
  FProvider := pProvider;
  FDateTime := pDateTime;
  Message := pMessage;
end;
{$ENDREGION}

{$REGION 'EIPGeoLocationRequestException'}
constructor EIPGeoLocationRequestException.Create(
  const pKind: TIPGeoLocationExceptionKind;
  const pIP: string; const pProvider: string; const pDateTime: TDateTime;
  const pURL: string; const pStatusCode: Integer;
  const pStatusText: string; const pMethod: string;
  const pMessage: string);
begin
  inherited Create(pKind, pIP, pProvider, pDateTime, pMessage);

  FURL := pURL;
  FStatusCode := pStatusCode;
  FStatusText := pStatusText;
  FMethod := pMethod;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationProviderKindHelper'}
function TIPGeoLocationProviderKindHelper.AsInteger: Integer;
begin
  Result := Ord(Self);
end;

function TIPGeoLocationProviderKindHelper.AsString: string;
begin
  case Self of
    TIPGeoLocationProviderKind.UNKNOWN:          Result := 'UNKNOWN';
    TIPGeoLocationProviderKind.IPInfo:           Result := 'IPInfo';
    TIPGeoLocationProviderKind.IPGeoLocation:    Result := 'IPGeoLocation';
    TIPGeoLocationProviderKind.IP2Location:      Result := 'IP2Location';
    TIPGeoLocationProviderKind.IP2LocationIO:      Result := 'IP2LocationIO';
    TIPGeoLocationProviderKind.IPApi:            Result := 'IPApi';
    TIPGeoLocationProviderKind.IPStack:          Result := 'IPStack';
    TIPGeoLocationProviderKind.IPIfy:            Result := 'IPIfy';
    TIPGeoLocationProviderKind.IPGeolocationAPI: Result := 'IPGeolocationAPI';
    TIPGeoLocationProviderKind.IPData:           Result := 'IPData';
    TIPGeoLocationProviderKind.IPWhois:          Result := 'IPWhois';
    TIPGeoLocationProviderKind.IPDig:            Result := 'IPDig';
    TIPGeoLocationProviderKind.IPTwist:          Result := 'IPTwist';
    TIPGeoLocationProviderKind.IPLabstack:       Result := 'IPLabstack';
    TIPGeoLocationProviderKind.IP_API:           Result := 'IP-API';
    TIPGeoLocationProviderKind.DB_IP:            Result := 'DB-IP';
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationExceptionKindHelper'}
function TIPGeoLocationExceptionKindHelper.AsInteger: Integer;
begin
  Result := Ord(Self);
end;

function TIPGeoLocationExceptionKindHelper.AsString: string;
begin
  case Self of
    TIPGeoLocationExceptionKind.EXCEPTION_UNKNOWN:           Result := 'EXCEPTION_UNKNOWN';
    TIPGeoLocationExceptionKind.EXCEPTION_OTHERS:            Result := 'EXCEPTION_OTHERS';
    TIPGeoLocationExceptionKind.EXCEPTION_HTTP:              Result := 'EXCEPTION_HTTP';
    TIPGeoLocationExceptionKind.EXCEPTION_PARAMS_NOT_FOUND:  Result := 'EXCEPTION_PARAMS_NOT_FOUND';
    TIPGeoLocationExceptionKind.EXCEPTION_API:               Result := 'EXCEPTION_API';
    TIPGeoLocationExceptionKind.EXCEPTION_JSON_INVALID:      Result := 'EXCEPTION_JSON_INVALID';
    TIPGeoLocationExceptionKind.EXCEPTION_NO_CONTENT:        Result := 'EXCEPTION_NO_CONTENT';
  end;
end;
{$ENDREGION}

end.
