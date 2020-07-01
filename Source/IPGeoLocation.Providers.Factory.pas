{******************************************************************************}
{                                                                              }
{           IPGeoLocation.Providers.Factory                                    }
{                                                                              }
{           Copyright (C) Ant�nio Jos� Medeiros Schneider J�nior               }
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
unit IPGeoLocation.Providers.Factory;

interface

uses IPGeoLocation.Types, IPGeoLocation.Interfaces;

type
  TIPGeoLocationProviderFactory = class sealed
  strict private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function New(const pProviderKind: TIPGeoLocationProviderKind;
                       const pIPGeoLocation: IIPGeoLocation;
                       const pIP: string): IIPGeoLocationProvider;
  end;

implementation

uses IPGeoLocation.Providers, System.SysUtils;

{$REGION 'TIPGeoLocationProviderFactory'}

class function TIPGeoLocationProviderFactory.New(const pProviderKind: TIPGeoLocationProviderKind;
  const pIPGeoLocation: IIPGeoLocation; const pIP: string): IIPGeoLocationProvider;
begin
  case pProviderKind of
    TIPGeoLocationProviderKind.UNKNOWN:           raise Exception.Create('Provider not implemented...');
    TIPGeoLocationProviderKind.IPInfo:            Result := TIPGeoLocationProviderIPInfo.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPGeoLocation:     Result := TIPGeoLocationProviderIPGeoLocation.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IP2Location:       Result := TIPGeoLocationProviderIP2Location.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPAPI:             Result := TIPGeoLocationProviderIPAPI.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPStack:           Result := TIPGeoLocationProviderIPStack.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPIfy:             Result := TIPGeoLocationProviderIPIfy.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPGeolocationAPI:  Result := TIPGeoLocationProviderIPGeolocationAPI.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPData:            Result := TIPGeoLocationProviderIPData.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPWhois:           Result := TIPGeoLocationProviderIPWhois.Create(pIPGeoLocation, pIP);
    TIPGeoLocationProviderKind.IPDig:             Result := TIPGeoLocationProviderIPDig.Create(pIPGeoLocation, pIP);
  else
    raise Exception.Create('Provider not implemented...');
  end;
end;

{$ENDREGION}

end.
