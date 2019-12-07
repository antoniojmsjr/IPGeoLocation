{******************************************************************************}
{                                                                              }
{           IPGeoLocation.Types                                                }
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
  TIPGeoLocationProviderKind = (UNKNOWN=0,
                                IPInfo=1,
                                IPGeoLocation=2,
                                IP2Location=3,
                                IPApi=4,
                                IPStack=5,
                                IPIfy=6,
                                IPGeolocationAPI=7,
                                IPData=8);

  TIPGeoLocationRequestLimitPerKind = (iglPer_UNKNOWN=0,
                                       iglPer_Day=1,
                                       iglPer_Month=2,
                                       iglPer_Year=3,
                                       iglPer_Free=4);

  TIPGeoLocationExceptionKind = (iglEXCEPTION_UNKNOWN=0,
                                 iglEXCEPTION_HTTP=1,
                                 iglEXCEPTION_PARAMS_NOT_FOUND=2,
                                 iglEXCEPTION_API=3,
                                 iglEXCEPTION_JSON_INVALID=4,
                                 iglEXCEPTION_NO_CONTENT=5);

  TEventIPGeoLocationResultString = procedure(const AValue: string) of object;

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

  EIPGeoLocationRequestException = class(EIPGeoLocationException)
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

  function IPGeoLocationExceptionKindToString(const pValue: TIPGeoLocationExceptionKind): string;

implementation

function IPGeoLocationExceptionKindToString(const pValue: TIPGeoLocationExceptionKind): string;
begin
  case pValue of
    TIPGeoLocationExceptionKind.iglEXCEPTION_UNKNOWN:
      Result := 'EXCEPTION_UNKNOWN';
    TIPGeoLocationExceptionKind.iglEXCEPTION_HTTP:
      Result := 'EXCEPTION_HTTP';
    TIPGeoLocationExceptionKind.iglEXCEPTION_PARAMS_NOT_FOUND:
      Result := 'EXCEPTION_PARAMS_NOT_FOUND';
    TIPGeoLocationExceptionKind.iglEXCEPTION_API:
      Result := 'EXCEPTION_API';
    TIPGeoLocationExceptionKind.iglEXCEPTION_JSON_INVALID:
      Result := 'EXCEPTION_JSON_INVALID';
    TIPGeoLocationExceptionKind.iglEXCEPTION_NO_CONTENT:
      Result := 'EXCEPTION_NO_CONTENT';
  end;
end;

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

end.
