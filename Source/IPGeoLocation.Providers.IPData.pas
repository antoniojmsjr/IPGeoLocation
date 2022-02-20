unit IPGeoLocation.Providers.IPData;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPData'}
  TIPGeoLocationProviderIPData = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPData'}
  TIPGeoLocationResponseIPData = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPData'}
  TIPGeoLocationRequestIPData = class sealed(TIPGeoLocationRequestCustom)
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

{$REGION 'TIPGeoLocationProviderIPData'}
constructor TIPGeoLocationProviderIPData.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPDATA';
  FURL    := 'https://api.ipdata.co';
  FAPIKey := APIKey_IPData; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPData.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPData.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPData'}
procedure TIPGeoLocationResponseIPData.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('country_code', FCountryCode);
    lJSONObject.TryGetValue('flag',         FCountryFlag);
    lJSONObject.TryGetValue('country_name', FCountryName);
    lJSONObject.TryGetValue('region',       FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('postal',       FZipCode);
    lJSONObject.TryGetValue('latitude',     FLatitude);
    lJSONObject.TryGetValue('longitude',    FLongitude);
    lJSONObject.GetValue('asn').TryGetValue('name', FISP);
    lJSONObject.GetValue('time_zone').TryGetValue('offset', FTimeZoneOffset);
    lJSONObject.GetValue('time_zone').TryGetValue('name',   FTimeZoneName);

  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPData'}
function TIPGeoLocationRequestIPData.GetMessageExceptionAPI(
  const pJSON: string): string;
var
  lJSONMessage: TJSONValue;
begin
  lJSONMessage := nil;
  try
    lJSONMessage := TJSONObject.ParseJSONValue(pJSON);
    if not Assigned(lJSONMessage) then
      Exit(pJSON);

    (lJSONMessage as TJSONObject).TryGetValue('message', Result);
  finally
    lJSONMessage.Free;
  end;
end;

function TIPGeoLocationRequestIPData.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIPData.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPData.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s', [FIPGeoLocationProvider.URL, FIP]));
  lURL.AddParameter('api-key', FIPGeoLocationProvider.APIKey);

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
