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

uses
  System.SysUtils, IPGeoLocation.Types, IPGeoLocation.Interfaces;

type

  {$REGION 'TIPGeoLocationProviderCustom'}

  TIPGeoLocationProviderCustom = class(TInterfacedObject, IIPGeoLocationProvider)
  strict private
    { private declarations }
    function GetID: string;
    function GetURI: string;
    function GetAPIKey: string;
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
    FIP: string;
    FID: string;
    FURI: string;
    FAPIKey: string;
    FRequestAccept: string;
    FRequestPer: TIPGeoLocationRequestLimitPerKind;
    FRequestLimit: LongInt;
    FAvailable: TDateTime;
    FTimeout: Integer;
    function GetRequest: IIPGeoLocationRequest; virtual; abstract;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); overload; virtual;
    constructor Create(pParent: IIPGeoLocation; const pIP: string); overload;
    function SetAPIKey(const pValue: string): IIPGeoLocationProvider;
    function SetTimeout(const pValue: Integer): IIPGeoLocationProvider;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPInfo'}

  TIPGeoLocationProviderIPInfo = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPGeoLocation'}

  TIPGeoLocationProviderIPGeoLocation = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIP2Location'}

  TIPGeoLocationProviderIP2Location = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPAPI'}

  TIPGeoLocationProviderIPAPI = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPStack'}

  TIPGeoLocationProviderIPStack = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPIfy'}

  TIPGeoLocationProviderIPIfy = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}

  TIPGeoLocationProviderIPGeolocationAPI = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPData'}

  TIPGeoLocationProviderIPData = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPWhois'}

  TIPGeoLocationProviderIPWhois = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

  {$REGION 'TIPGeoLocationProviderIPDig'}

  TIPGeoLocationProviderIPDig = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation); override;
  end;

  {$ENDREGION}

implementation

uses
  IPGeoLocation.Request;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderCustom'}

constructor TIPGeoLocationProviderCustom.Create(pParent: IIPGeoLocation);
begin
  FIPGeoLocation := pParent;
  FURI := EmptyStr;
  FAPIKey := EmptyStr;
  FRequestAccept := EmptyStr;
  FRequestPer := TIPGeoLocationRequestLimitPerKind.iglPer_UNKNOWN;
  FRequestLimit := 0;
  FTimeout := 30000;
  FAvailable := 0;
end;

constructor TIPGeoLocationProviderCustom.Create(pParent: IIPGeoLocation; const pIP: string);
begin
  Create(pParent);
  FIP := pIP;
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

function TIPGeoLocationProviderCustom.GetAPIKey: string;
begin
  Result := FAPIKey;
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

function TIPGeoLocationProviderCustom.SetAPIKey(
  const pValue: string): IIPGeoLocationProvider;
begin
  Result := Self;
  FAPIKey := pValue;
end;

function TIPGeoLocationProviderCustom.SetTimeout(
  const pValue: Integer): IIPGeoLocationProvider;
begin
  Result := Self;
  FTimeout := pValue;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPInfo'}

constructor TIPGeoLocationProviderIPInfo.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPINFO';
  FURI            := 'https://ipinfo.io';
  FAPIKey         := APIKey_IPInfo;
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_month;
  FRequestLimit   := 50000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPInfo.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPInfo.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPGeoLocation'}
constructor TIPGeoLocationProviderIPGeoLocation.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPGEOLOCATION';
  FURI            := 'https://api.ipgeolocation.io/ipgeo';
  FAPIKey         := APIKey_IPGeoLocation; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 30000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPGeoLocation.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPGeoLocation.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIP2Location'}

constructor TIPGeoLocationProviderIP2Location.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IP2LOCATION';
  FURI            := 'https://api.ip2location.com';
  FAPIKey         := APIKey_IP2Location; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Day;
  FRequestLimit   := 200;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIP2Location.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIP2Location.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPAPI'}

constructor TIPGeoLocationProviderIPAPI.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPAPI';
  FURI            := 'http://api.ipapi.com/api/';
  FAPIKey         := APIKey_IPAPI; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPAPI.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPAPI.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPStack'}

constructor TIPGeoLocationProviderIPStack.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPSTACK';
  FURI            := 'http://api.ipstack.com';
  FAPIKey         := APIKey_IPStack; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPStack.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPStack.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPIfy'}

constructor TIPGeoLocationProviderIPIfy.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPIFY';
  FURI            := 'https://geo.ipify.org/api/v1/';
  FAPIKey         := APIKey_IPIfy; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPIfy.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPIfy.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}

constructor TIPGeoLocationProviderIPGeolocationAPI.Create(
  pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPGEOLOCATIONAPI';
  FURI            := 'https://api.ipgeolocationapi.com/geolocate';
  FAPIKey         := APIKey_IPGeolocationAPI; //FULL FREE
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Free;
  FRequestLimit   := 0;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPGeolocationAPI.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPGeolocationAPI.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPData'}

constructor TIPGeoLocationProviderIPData.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPDATA';
  FURI            := 'https://api.ipdata.co';
  FAPIKey         := APIKey_IPData; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Day;
  FRequestLimit   := 1500;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPData.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPData.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPWhois'}

constructor TIPGeoLocationProviderIPWhois.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPWHOIS';
  FURI            := 'http://ipwhois.app';
  FAPIKey         := APIKey_IPWhois; //TOKEN
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPWhois.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPWhois.Create(Self, FIP);
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPDig'}

constructor TIPGeoLocationProviderIPDig.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID             := '#IPDIG';
  FURI            := 'https://ipdig.io';
  FAPIKey         := APIKey_IPDig; //FULL FREE
  FRequestAccept  := 'application/json';
  FRequestPer     := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit   := 10000;
  FAvailable      := 0;
end;

function TIPGeoLocationProviderIPDig.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPDig.Create(Self, FIP);
end;

{$ENDREGION}

end.
