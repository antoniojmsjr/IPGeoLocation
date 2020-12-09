unit IPGeoLocation.Providers.IPLabstack;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient,
  System.Classes;

type

  {$REGION 'TIPGeoLocationProviderIPLabstack'}
  TIPGeoLocationProviderIPLabstack = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPLabstack'}
  TIPGeoLocationResponseIPLabstack = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPLabstack'}
  TIPGeoLocationRequestIPLabstack = class sealed(TIPGeoLocationRequestCustom)
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

{$REGION 'TIPGeoLocationProviderIPLabstack'}
constructor TIPGeoLocationProviderIPLabstack.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPLABSTACK';
  FURL    := 'https://ip.labstack.com';
  FAPIKey := Trim(APIKey_IPLabstack); //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPLabstack.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPLabstack.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPLabstack'}
procedure TIPGeoLocationResponseIPLabstack.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('hostname',     FHostName);
    lJSONObject.TryGetValue('country_code', FCountryCode);
    lJSONObject.TryGetValue('country',      FCountryName);
    lJSONObject.TryGetValue('region',       FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('postal',       FZipCode);
    lJSONObject.TryGetValue('latitude',     FLatitude);
    lJSONObject.TryGetValue('longitude',    FLongitude);

    //ISP
    lJSONObject.GetValue('organization').TryGetValue('name', FISP);

    //TIMEZONE
    lJSONObject.GetValue('time_zone').TryGetValue('name',   FTimeZoneName);
    lJSONObject.GetValue('time_zone').TryGetValue('offset', FTimeZoneOffset);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPLabstack'}
function TIPGeoLocationRequestIPLabstack.GetResponse(
  pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse;
begin
  Result := TIPGeoLocationResponseIPLabstack.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPLabstack.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/%s', [FIPGeoLocationProvider.URL, 'api/v1', FIP]));

  FHttpRequest.URL := lURL.ToString;

  //API KEY
  FRequestHeaders := FRequestHeaders + [TNetHeader.Create('Authorization', Format('Bearer %s', [FIPGeoLocationProvider.APIKey]))];

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
