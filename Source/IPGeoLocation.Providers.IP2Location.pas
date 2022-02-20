unit IPGeoLocation.Providers.IP2Location;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIP2Location'}
  TIPGeoLocationProviderIP2Location = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIP2Location'}
  TIPGeoLocationResponseIP2Location = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIP2Location'}
  TIPGeoLocationRequestIP2Location = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IGeoLocation; override;
    function GetMessageExceptionAPI(const pJSON: string): string; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string); override;
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient, IPGeoLocation.Types;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIP2Location'}
constructor TIPGeoLocationProviderIP2Location.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IP2LOCATION';
  FURL    := 'https://api.ip2location.com';
  FAPIKey := APIKey_IP2Location; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIP2Location.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIP2Location.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIP2Location'}
procedure TIPGeoLocationResponseIP2Location.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('country_code', FCountryCode);
    lJSONObject.GetValue('country').TryGetValue('alpha3_code', FCountryCode3);
    lJSONObject.GetValue('country').TryGetValue('flag',        FCountryFlag);
    lJSONObject.GetValue('country').TryGetValue('name',        FCountryName);
    lJSONObject.TryGetValue('region_name', FState);
    lJSONObject.TryGetValue('city_name',   FCity);
    lJSONObject.TryGetValue('zip_code',    FZipCode);
    lJSONObject.TryGetValue('isp',         FISP);
    lJSONObject.TryGetValue('latitude',    FLatitude);
    lJSONObject.TryGetValue('longitude',   FLongitude);

    //TIMEZONE
    lJSONObject.TryGetValue('time_zone', FTimeZoneOffset);
    lJSONObject.GetValue('time_zone_info').TryGetValue('olson', FTimeZoneName);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIP2Location'}
constructor TIPGeoLocationRequestIP2Location.Create(
  pParent: IIPGeoLocationProvider; const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguageCode := 'en';
end;

function TIPGeoLocationRequestIP2Location.GetMessageExceptionAPI(
  const pJSON: string): string;
var
  lJSONMessage: TJSONValue;
begin
  lJSONMessage := nil;
  try
    lJSONMessage := TJSONObject.ParseJSONValue(pJSON);
    if not Assigned(lJSONMessage) then
      Exit(pJSON);

    (lJSONMessage as TJSONObject).TryGetValue('response', Result);
  finally
    lJSONMessage.Free;
  end;
end;

function TIPGeoLocationRequestIP2Location.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIP2Location.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIP2Location.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lJSONObject: TJSONObject;
  lResponseAPI: string;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/', [FIPGeoLocationProvider.URL, 'v2']));
  lURL.AddParameter('key', FIPGeoLocationProvider.APIKey);
  lURL.AddParameter('ip', FIP);
  lURL.AddParameter('lang', FResponseLanguageCode);
  lURL.AddParameter('format', 'json');
  lURL.AddParameter('package', 'WS24');
  lURL.AddParameter('addon', 'country,time_zone_info');

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;

  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(Result.ContentAsString) as TJSONObject;

    //CONFORME A DOCUMENTAÇÃO DA API
    if lJSONObject.TryGetValue('response', lResponseAPI) then
    begin
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.EXCEPTION_API,
                                           FIP,
                                           FProvider,
                                           Now(),
                                           lResponseAPI);
    end;
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

end.
