unit IPGeoLocation.Providers.IPIfy;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPIfy'}
  TIPGeoLocationProviderIPIfy = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPIfy'}
  TIPGeoLocationResponseIPIfy = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPIfy'}
  TIPGeoLocationRequestIPIfy = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPIfy'}
constructor TIPGeoLocationProviderIPIfy.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPIFY';
  FURL    := 'https://geo.ipify.org/api';
  FAPIKey := APIKey_IPIfy; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPIfy.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPIfy.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPIfy'}
procedure TIPGeoLocationResponseIPIfy.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.GetValue('location').TryGetValue('country',     FCountryCode);
    lJSONObject.GetValue('location').TryGetValue('region',      FState);
    lJSONObject.GetValue('location').TryGetValue('city',        FCity);
    lJSONObject.GetValue('location').TryGetValue('lat',         FLatitude);
    lJSONObject.GetValue('location').TryGetValue('lng',         FLongitude);
    lJSONObject.GetValue('location').TryGetValue('postalCode',  FZipCode);
    lJSONObject.GetValue('location').TryGetValue('timezone',    FTimeZoneOffset);
    lJSONObject.TryGetValue('isp', FISP);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPIfy'}
function TIPGeoLocationRequestIPIfy.GetResponse(
  pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse;
begin
  Result := TIPGeoLocationResponseIPIfy.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPIfy.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/', [FIPGeoLocationProvider.URL, 'v1']));
  lURL.AddParameter('apiKey', FIPGeoLocationProvider.APIKey);
  lURL.AddParameter('ipAddress', FIP);

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
