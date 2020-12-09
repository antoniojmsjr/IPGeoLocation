unit IPGeoLocation.Providers.IPGeoLocation;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPGeoLocation'}
  TIPGeoLocationProviderIPGeoLocation = class sealed(TIPGeoLocationProviderCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetRequest: IIPGeoLocationRequest; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocation; const pIP: string); override;
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationResponseIPGeoLocation'}
  TIPGeoLocationResponseIPGeoLocation = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPGeoLocation'}
  TIPGeoLocationRequestIPGeoLocation = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string); override;
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient, IPGeoLocation.Types;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPGeoLocation'}
constructor TIPGeoLocationProviderIPGeoLocation.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPGEOLOCATION';
  FURL    := 'https://api.ipgeolocation.io';
  FAPIKey := Trim(APIKey_IPGeoLocation); //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPGeoLocation.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPGeoLocation.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPGeoLocation'}
procedure TIPGeoLocationResponseIPGeoLocation.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FJSON), 0) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('hostname',       FHostName);
    lJSONObject.TryGetValue('country_code2',  FCountryCode);
    lJSONObject.TryGetValue('country_code3',  FCountryCode3);
    lJSONObject.TryGetValue('country_name',   FCountryName);
    lJSONObject.TryGetValue('country_flag',   FCountryFlag);
    lJSONObject.TryGetValue('state_prov',     FState);
    lJSONObject.TryGetValue('city',           FCity);
    lJSONObject.TryGetValue('zipcode',        FZipCode);
    lJSONObject.TryGetValue('isp',            FISP);
    lJSONObject.TryGetValue('latitude',       FLatitude);
    lJSONObject.TryGetValue('longitude',      FLongitude);

    //TIMEZONE
    lJSONObject.GetValue('time_zone').TryGetValue('name',   FTimeZoneName);
    lJSONObject.GetValue('time_zone').TryGetValue('offset', FTimeZoneOffset);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPGeoLocation'}
constructor TIPGeoLocationRequestIPGeoLocation.Create(
  pParent: IIPGeoLocationProvider; const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguage := 'en';
end;

function TIPGeoLocationRequestIPGeoLocation.GetResponse(
  pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse;
begin
  Result := TIPGeoLocationResponseIPGeoLocation.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPGeoLocation.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s', [FIPGeoLocationProvider.URL, 'ipgeo']));
  lURL.AddParameter('apiKey', FIPGeoLocationProvider.APIKey);
  lURL.AddParameter('ip', FIP);
  lURL.AddParameter('lang', FResponseLanguage);
  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
