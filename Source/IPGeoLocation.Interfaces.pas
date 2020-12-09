{******************************************************************************}
{                                                                              }
{           IPGeoLocation.Interfaces                                           }
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
unit IPGeoLocation.Interfaces;

interface

uses IPGeoLocation.Types, System.SysUtils;

type

  IIPGeoLocationProvider = interface;
  IIPGeoLocationRequest = interface;
  IIPGeoLocationResponse = interface;

  IIPGeoLocation = interface
    ['{C1592BED-B268-46B1-86FF-243123F7C3E2}']
    function GetIP(const Value: string): IIPGeoLocation;
    function GetProvider(const Value: TIPGeoLocationProviderKind): IIPGeoLocationProvider; //RECUPERA AS INFORMAÇÕES NO BANCO DE DADOS/ARQUIVO INI ETC..

    property IP[const Value: string]: IIPGeoLocation read GetIP;
    property Provider[const Value: TIPGeoLocationProviderKind]: IIPGeoLocationProvider read GetProvider;
  end;

  IIPGeoLocationProvider = interface
    ['{DF8EB3BB-7216-4118-BDB9-37ABE51F252E}']
    function GetID: string;
    function GetURL: string;
    function GetAPIKey: string;
    function GetTimeout: Integer;
    function GetRequest: IIPGeoLocationRequest;

    function SetAPIKey(const APIKey: string): IIPGeoLocationProvider;
    function SetTimeout(const Timeout: Integer): IIPGeoLocationProvider;

    property ID: string read GetID;
    property URL: string read GetURL;
    property APIKey: string read GetAPIKey;
    property Timeout: Integer read GetTimeout;
    property Request: IIPGeoLocationRequest read GetRequest;
  end;

  IIPGeoLocationRequest = interface
    ['{88307C45-E391-4E40-AF73-2FBAB5B1F74B}']
    function Execute: IIPGeoLocationResponse;
    function SetResponseLanguage(const Language: string): IIPGeoLocationRequest;
  end;

  IIPGeoLocationResponse = interface
    ['{2BA0D4A4-9F3C-4CFF-A485-7EB7FD0638A9}']
    function GetIP: string;
    function GetProvider: string;
    function GetDateTime: TDateTime;
    function GetHostName: string;
    function GetCountryCode: string;
    function GetCountryCode3: string;
    function GetCountryName: string;
    function GetCountryFlag: string;
    function GetState: string;
    function GetCity: string;
    function GetZipCode: string;
    function GetLatitude: Extended;
    function GetLongitude: Extended;
    function GetTimeZoneName: string;
    function GetTimeZoneOffset: string;
    function GetISP: string;

    function ToJSON: string;

    property IP: string read GetIP;
    property Provider: string read GetProvider;
    property DateTime: TDateTime read GetDateTime;
    property HostName: string read GetHostName;
    property CountryCode: string read GetCountryCode;
    property CountryCode3: string read GetCountryCode3;
    property CountryName: string read GetCountryName;
    property CountryFlag: string read GetCountryFlag;
    property State: string read GetState;
    property City: string read GetCity;
    property ZipCode: string read GetZipCode;
    property Latitude: Extended read GetLatitude;
    property Longitude: Extended read GetLongitude;
    property TimeZoneName: string read GetTimeZoneName;
    property TimeZoneOffset: string read GetTimeZoneOffset;
    property ISP: string read GetISP;
  end;

implementation

end.
