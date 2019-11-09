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

  IIPGeoLocation = interface
    ['{938C5905-D014-40B3-880D-44D53E8FC5DD}']
    function GetIP(const Value: string): IIPGeoLocation;
    function GetProvider(const Value: TIPGeoLocationProviderType): IIPGeoLocationProvider; //RECUPERA AS INFORMAÇÕES NO BANCO DE DADOS/ARQUIVO INI ETC..

    property IP[const Value: string]: IIPGeoLocation read GetIP;
    property Provider[const Value: TIPGeoLocationProviderType]: IIPGeoLocationProvider read GetProvider;
  end;

  //INFORMAÇÕES DO PROVEDOR DA API
  IIPGeoLocationProvider = interface
    ['{D1A4E37B-21E2-4B52-9B24-234DCA01ABDD}']
    function GetID: string;
    function GetURI: string;
    function GetRequestAccept: string;
    function GetKey: string;
    function GetRequestPer: TIPGeoLocationRequestLimitPer;
    function GetRequestLimit: LongInt;
    function GetAvailable: TDateTime;
    function GetTimeout: Integer;
    function Settings: IIPGeoLocationProvider;
    function GetRequest: IIPGeoLocationRequest;
    function GetEnd: IIPGeoLocation;

    property ID: string read GetID;
    property URI: string read GetURI;
    property Key: string read GetKey;
    property RequestAccept: string read GetRequestAccept;
    property RequestPer: TIPGeoLocationRequestLimitPer read GetRequestPer;
    property RequestLimit: LongInt read GetRequestLimit;
    property Available: TDateTime read GetAvailable;
    property Timeout: Integer read GetTimeout;
    property Request: IIPGeoLocationRequest read GetRequest;
    property &End: IIPGeoLocation read GetEnd;
  end;

  IIPGeoLocationRequest = interface
    ['{D0D9674D-ABE9-46BD-B417-4BA685413B19}']
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
    function Execute: IIPGeoLocationRequest;
    function ToJSON(pResult: TEventIPGeoLocationResultString): IIPGeoLocationRequest;
    function GetEnd: IIPGeoLocationProvider;

    property IP: string read GetIP;
    property Provider: string read GetProvider;
    property HostName: string read GetHostName;
    property CountryCode: string read GetCountryCode;
    property CountryCode3: string read GetCountryCode3;
    property CountryName: string read GetCountryName;
    property CountryFlag: string read GetCountryFlag; //URL
    property Region: string read GetRegion;
    property City: string read GetCity;
    property ZipCode: string read GetZipCode;
    property Latitude: double read GetLatitude;
    property Longitude: double read GetLongitude;
    property TimeZoneName: string read GetTimeZoneName;
    property TimeZoneOffset: string read GetTimeZoneOffset;
    property ISP: string read GetISP;
    property &End: IIPGeoLocationProvider read GetEnd;
  end;

implementation

end.
