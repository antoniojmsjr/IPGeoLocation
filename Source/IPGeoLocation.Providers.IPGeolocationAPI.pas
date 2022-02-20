unit IPGeoLocation.Providers.IPGeolocationAPI;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}
  TIPGeoLocationProviderIPGeolocationAPI = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPGeolocationAPI'}
  TIPGeoLocationResponseIPGeolocationAPI = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPGeolocationAPI'}
  TIPGeoLocationRequestIPGeolocationAPI = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IGeoLocation; override;
    function GetMessageExceptionAPI(const pJSON: string): string; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPGeolocationAPI'}
constructor TIPGeoLocationProviderIPGeolocationAPI.Create(
  pParent: IIPGeoLocation; const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPGEOLOCATIONAPI';
  FURL    := 'https://api.ipgeolocationapi.com';
  FAPIKey := APIKey_IPGeolocationAPI; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPGeolocationAPI.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPGeolocationAPI.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPGeolocationAPI'}
procedure TIPGeoLocationResponseIPGeolocationAPI.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('alpha2', FCountryCode);
    lJSONObject.TryGetValue('alpha3', FCountryCode3);
    lJSONObject.GetValue('geo').TryGetValue('latitude',  FLatitude);
    lJSONObject.GetValue('geo').TryGetValue('longitude', FLongitude);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPGeolocationAPI'}
function TIPGeoLocationRequestIPGeolocationAPI.GetMessageExceptionAPI(
  const pJSON: string): string;
begin
  Result := pJSON;
end;

function TIPGeoLocationRequestIPGeolocationAPI.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIPGeolocationAPI.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPGeolocationAPI.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/%s', [FIPGeoLocationProvider.URL, 'geolocate', FIP]));

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
