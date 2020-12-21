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
  TIPGeoLocationProviderKind = (UNKNOWN,
                                IPInfo,
                                IPGeoLocation,
                                IP2Location,
                                IPApi,
                                IPStack,
                                IPIfy,
                                IPGeolocationAPI,
                                IPData,
                                IPWhois,
                                IPDig,
                                IPTwist,
                                IPLabstack);

  TIPGeoLocationExceptionKind = (iglEXCEPTION_UNKNOWN,
                                 iglEXCEPTION_OTHERS,
                                 iglEXCEPTION_HTTP,
                                 iglEXCEPTION_PARAMS_NOT_FOUND,
                                 iglEXCEPTION_API,
                                 iglEXCEPTION_JSON_INVALID,
                                 iglEXCEPTION_NO_CONTENT);

  {$REGION 'EIPGeoLocationException'}

  EIPGeoLocationException = class(Exception)
  strict private
    { private declarations }
  protected
    { protected declarations }
    FProvider: string;
    FKind: TIPGeoLocationExceptionKind;
  public
    { public declarations }
    constructor Create(const pKind: TIPGeoLocationExceptionKind;
                       const pProvider: string;
                       const pMessage: string);
    property Kind: TIPGeoLocationExceptionKind read FKind;
    property Provider: string read FProvider;
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
                       const pProvider: string;
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

implementation

{$REGION 'EIPGeoLocationException'}

constructor EIPGeoLocationException.Create(const pKind: TIPGeoLocationExceptionKind;
  const pProvider: string;
  const pMessage: string);
begin
  FKind := pKind;
  FProvider := pProvider;
  Message := pMessage;
end;

{$ENDREGION}

{$REGION 'EIPGeoLocationRequestException'}

constructor EIPGeoLocationRequestException.Create(const pKind: TIPGeoLocationExceptionKind;
  const pProvider: string; const pURL: string; const pStatusCode: Integer;
  const pStatusText: string; const pMethod: string;
  const pMessage: string);
begin
  FKind := pKind;
  FProvider := pProvider;
  FURL := pURL;
  FStatusCode := pStatusCode;
  FStatusText := pStatusText;
  FMethod := pMethod;
  Message := pMessage;
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
    UNKNOWN:          Result := 'UNKNOWN';
    IPInfo:           Result := 'IPInfo';
    IPGeoLocation:    Result := 'IPGeoLocation';
    IP2Location:      Result := 'IP2Location';
    IPApi:            Result := 'IPApi';
    IPStack:          Result := 'IPStack';
    IPIfy:            Result := 'IPIfy';
    IPGeolocationAPI: Result := 'IPGeolocationAPI';
    IPData:           Result := 'IPData';
    IPWhois:          Result := 'IPWhois';
    IPDig:            Result := 'IPDig';
    IPTwist:          Result := 'IPTwist';
    IPLabstack:       Result := 'IPLabstack';
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
    iglEXCEPTION_UNKNOWN:           Result := 'EXCEPTION_UNKNOWN';
    iglEXCEPTION_OTHERS:            Result := 'EXCEPTION_OTHERS';
    iglEXCEPTION_HTTP:              Result := 'EXCEPTION_HTTP';
    iglEXCEPTION_PARAMS_NOT_FOUND:  Result := 'EXCEPTION_PARAMS_NOT_FOUND';
    iglEXCEPTION_API:               Result := 'EXCEPTION_API';
    iglEXCEPTION_JSON_INVALID:      Result := 'EXCEPTION_JSON_INVALID';
    iglEXCEPTION_NO_CONTENT:        Result := 'EXCEPTION_NO_CONTENT';
  end;
end;

{$ENDREGION}

end.
