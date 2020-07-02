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

uses IPGeoLocation.Types;

type

  IIPGeoLocationProvider = interface;
  IIPGeoLocationRequest = interface;
  IIPGeoLocationResponse = interface;

  TIPGeoLocationOnResponseEvent = procedure(const AResponse: IIPGeoLocationResponse) of object;

  IIPGeoLocation = interface
    ['{C1592BED-B268-46B1-86FF-243123F7C3E2}']
    function GetIP(const Value: string): IIPGeoLocation;
    function GetProvider(const Value: TIPGeoLocationProviderKind): IIPGeoLocationProvider; //RECUPERA AS INFORMAÇÕES NO BANCO DE DADOS/ARQUIVO INI ETC..

    property IP[const Value: string]: IIPGeoLocation read GetIP;
    property Provider[const Value: TIPGeoLocationProviderKind]: IIPGeoLocationProvider read GetProvider;
  end;

  IIPGeoLocationProvider = interface
    ['{64985947-8AEC-4417-BB34-59FC7496EE3A}']
    function GetID: string;
    function GetURI: string;
    function GetRequestAccept: string;
    function GetAPIKey: string;
    function GetRequestPer: TIPGeoLocationRequestLimitPerKind;
    function GetRequestLimit: LongInt;
    function GetAvailable: TDateTime;
    function GetTimeout: Integer;
    function GetRequest: IIPGeoLocationRequest;
    function GetEnd: IIPGeoLocation;

    function SetAPIKey(const Value: string): IIPGeoLocationProvider;
    function SetTimeout(const Value: Integer): IIPGeoLocationProvider;

    property ID: string read GetID;
    property URI: string read GetURI;
    property APIKey: string read GetAPIKey;
    property RequestAccept: string read GetRequestAccept;
    property RequestPer: TIPGeoLocationRequestLimitPerKind read GetRequestPer;
    property RequestLimit: LongInt read GetRequestLimit;
    property Available: TDateTime read GetAvailable;
    property Timeout: Integer read GetTimeout;
    property Request: IIPGeoLocationRequest read GetRequest;
    property &End: IIPGeoLocation read GetEnd;
  end;

  IIPGeoLocationRequest = interface
    ['{88307C45-E391-4E40-AF73-2FBAB5B1F74B}']
    function GetEnd: IIPGeoLocationProvider;
    function GetResponse: IIPGeoLocationResponse;

    function Execute: IIPGeoLocationRequest;
    function OnResponse(const Method: TIPGeoLocationOnResponseEvent): IIPGeoLocationRequest;

    function SetResponseLanguage(const Language: string): IIPGeoLocationRequest;

    property Response: IIPGeoLocationResponse read GetResponse;
    property &End: IIPGeoLocationProvider read GetEnd;
  end;

  IIPGeoLocationResponse = interface
    ['{2BA0D4A4-9F3C-4CFF-A485-7EB7FD0638A9}']
    function GetIP: string;
    function GetProvider: string;
    function GetHostName: string;
    function GetCountryCode: string;
    function GetCountryCode3: string;
    function GetCountryName: string;
    function GetCountryFlag: string;
    function GetRegion: string;
    function GetCity: string;
    function GetZipCode: string;
    function GetLatitude: double;
    function GetLongitude: double;
    function GetTimeZoneName: string;
    function GetTimeZoneOffset: string;
    function GetISP: string;
    function GetJSON: string;

    property IP: string read GetIP;
    property Provider: string read GetProvider;
    property HostName: string read GetHostName;
    property CountryCode: string read GetCountryCode;
    property CountryCode3: string read GetCountryCode3;
    property CountryName: string read GetCountryName;
    property CountryFlag: string read GetCountryFlag;
    property Region: string read GetRegion;
    property City: string read GetCity;
    property ZipCode: string read GetZipCode;
    property Latitude: double read GetLatitude;
    property Longitude: double read GetLongitude;
    property TimeZoneName: string read GetTimeZoneName;
    property TimeZoneOffset: string read GetTimeZoneOffset;
    property ISP: string read GetISP;
    property JSON: string read GetJSON;
  end;

implementation

end.
