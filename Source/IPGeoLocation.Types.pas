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
  TIPGeoLocationProviderType = (UNKNOWN=0, IPInfo=1, IPGeoLocation=2,
                                IP2Location=3, IPApi=4, IPStack=5,
                                IPIfy=6, IPGeolocationAPI=7,
                                IPData=8);

  TIPGeoLocationRequestLimitPer = (iglPer_UNKNOWN=0,
                                   iglPer_Day=1,
                                   iglPer_Month=2,
                                   iglPer_Year=3,
                                   iglPer_Free=4);

  TIPGeoLocationExceptionKind = (iglEXCEPT_UNKNOWN=0,
                                 iglEXCEPT_HTTP=1,
                                 iglEXCEPT_PARAMS_NOT_FOUND=2,
                                 iglEXCEPT_API=3,
                                 iglEXCEPT_JSON_INVALID=4,
                                 iglEXCEPT_NO_CONTENT=5);

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
    TIPGeoLocationExceptionKind.iglEXCEPT_UNKNOWN:
      Result := 'EXCEPT_UNKNOWN';
    TIPGeoLocationExceptionKind.iglEXCEPT_HTTP:
      Result := 'EXCEPT_HTTP';
    TIPGeoLocationExceptionKind.iglEXCEPT_PARAMS_NOT_FOUND:
      Result := 'EXCEPT_PARAMS_NOT_FOUND';
    TIPGeoLocationExceptionKind.iglEXCEPT_API:
      Result := 'EXCEPT_API';
    TIPGeoLocationExceptionKind.iglEXCEPT_JSON_INVALID:
      Result := 'EXCEPT_JSON_INVALID';
    TIPGeoLocationExceptionKind.iglEXCEPT_NO_CONTENT:
      Result := 'EXCEPT_NO_CONTENT';
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
