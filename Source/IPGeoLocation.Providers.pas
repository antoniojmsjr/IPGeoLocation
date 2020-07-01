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

  {$REGION 'TIPGeoLocationProviderIPInfo'}

  TIPGeoLocationProviderIPInfo = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPGeoLocation'}

  TIPGeoLocationProviderIPGeoLocation = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIP2Location'}

  TIPGeoLocationProviderIP2Location = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPAPI'}

  TIPGeoLocationProviderIPAPI = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPStack'}

  TIPGeoLocationProviderIPStack = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPIfy'}

  TIPGeoLocationProviderIPIfy = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}

  TIPGeoLocationProviderIPGeolocationAPI = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPData'}

  TIPGeoLocationProviderIPData = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPWhois'}

  TIPGeoLocationProviderIPWhois = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationProviderIPDig'}

  TIPGeoLocationProviderIPDig = class sealed(TIPGeoLocationProviderCustom)
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

implementation

uses
  IPGeoLocation.Providers.Request;

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
    raise EIPGeoLocationException.Create(
      TIPGeoLocationExceptionKind.iglEXCEPTION_PARAMS_NOT_FOUND,
      FID,
      'Configuration not informed.');
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
  FURI              := 'https://ipinfo.io';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_month;
  FRequestLimit     := 50000;
  FAvailable        := 0;
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
  FURI              := 'https://api.ipgeolocation.io/ipgeo';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit     := 30000;
  FAvailable        := 0;
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
  FURI              := 'https://api.ip2location.com/v2/';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Day;
  FRequestLimit     := 200;
  FAvailable        := 0;
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
  FURI              := 'http://api.ipapi.com/api/';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit     := 10000;
  FAvailable        := 0;
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
  FURI              := 'http://api.ipstack.com/';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit     := 10000;
  FAvailable        := 0;
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
  FURI              := 'https://geo.ipify.org/api/v1/';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit     := 10000;
  FAvailable        := 0;
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
  FURI              := 'https://api.ipgeolocationapi.com/geolocate';
  FKey              := EmptyStr; //FULL FREE
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Free;
  FRequestLimit     := 0;
  FAvailable        := 0;
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
  FURI              := 'https://api.ipdata.co';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Day;
  FRequestLimit     := 1500;
  FAvailable        := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPWhois'}

constructor TIPGeoLocationProviderIPWhois.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPWHOIS';
end;

function TIPGeoLocationProviderIPWhois.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPWhois.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPWhois.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI              := 'http://ipwhois.app/';
  FKey              := 'TOKEN';
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit     := 10000;
  FAvailable        := 0;
end;

{$ENDREGION}

{$REGION 'TIPGeoLocationProviderIPDig'}

constructor TIPGeoLocationProviderIPDig.Create(pParent: IIPGeoLocation);
begin
  inherited;
  FID := '#IPDIG';
end;

function TIPGeoLocationProviderIPDig.GetRequest: IIPGeoLocationRequest;
begin
  inherited;
  Result := TIPGeoLocationRequestIPDig.Create(Self, FIP);
end;

function TIPGeoLocationProviderIPDig.Settings: IIPGeoLocationProvider;
begin
  Result := inherited;

  FSettingsExecuted := True;
  FURI              := 'https://ipdig.io/';
  FKey              := EmptyStr; //FULL FREE
  FRequestAccept    := 'application/json';
  FRequestPer       := TIPGeoLocationRequestLimitPerKind.iglPer_Month;
  FRequestLimit     := 10000;
  FAvailable        := 0;
end;

{$ENDREGION}

end.
