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
unit IPGeoLocation;

interface

uses System.SysUtils, System.Classes, IPGeoLocation.Types, IPGeoLocation.Interfaces;

type

  {$REGION 'TIPGeoLocation'}

  TIPGeoLocation = class sealed(TInterfacedObject, IIPGeoLocation)
  strict private
    { private declarations }
    FIP: string;
    function GetIP(const Value: string): IIPGeoLocation;
    function GetProvider(const Value: TIPGeoLocationProviderKind): IIPGeoLocationProvider;
  protected
    { protected declarations }
  public
    { public declarations }
    class function New: IIPGeoLocation;
  end;

  {$ENDREGION}

implementation

uses IPGeoLocation.Factory;

{$REGION 'TIPGeoLocation'}

class function TIPGeoLocation.New: IIPGeoLocation;
begin
  Result := Self.Create();
end;

function TIPGeoLocation.GetProvider(
  const Value: TIPGeoLocationProviderKind): IIPGeoLocationProvider;
begin
  Result := TIPGeoLocationProviderFactory.New(Value, Self, FIP);
end;

function TIPGeoLocation.GetIP(const Value: string): IIPGeoLocation;
begin
  Result := Self;
  FIP := Value;
end;

{$ENDREGION}

end.
