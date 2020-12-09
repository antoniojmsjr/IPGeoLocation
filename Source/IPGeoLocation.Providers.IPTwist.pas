unit IPGeoLocation.Providers.IPTwist;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient,
  System.Classes;

type

  {$REGION 'TIPGeoLocationProviderIPTwist'}
  TIPGeoLocationProviderIPTwist = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPTwist'}
  TIPGeoLocationResponseIPTwist = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPTwist'}
  TIPGeoLocationRequestIPTwist = class sealed(TIPGeoLocationRequestCustom)
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

{$REGION 'TIPGeoLocationProviderIPTwist'}
constructor TIPGeoLocationProviderIPTwist.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPTWIST';
  FURL    := 'https://iptwist.com';
  FAPIKey := Trim(APIKey_IPTwist); //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPTwist.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPTwist.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPTwist'}
procedure TIPGeoLocationResponseIPTwist.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('country_code', FCountryCode);
    lJSONObject.TryGetValue('country',      FCountryName);
    lJSONObject.TryGetValue('state',        FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('zip',          FZipCode);
    lJSONObject.TryGetValue('latitude',     FLatitude);
    lJSONObject.TryGetValue('longitude',    FLongitude);
    lJSONObject.TryGetValue('timezone',     FTimeZoneOffset);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPTwist'}
function TIPGeoLocationRequestIPTwist.GetResponse(
  pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse;
begin
  Result := TIPGeoLocationResponseIPTwist.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPTwist.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lBody: TStringStream;
  lIP: TJSONObject;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s', [FIPGeoLocationProvider.URL]));
  FHttpRequest.URL := lURL.ToString;
  FHttpRequest.MethodString := 'POST';
  FHttpRequest.Client.ContentType := 'application/json';

  //API KEY
  FRequestHeaders := FRequestHeaders + [TNetHeader.Create('X-IPTWIST-TOKEN', FIPGeoLocationProvider.APIKey)];

  lIP := nil;
  lBody := nil;
  try
    lIP := TJSONObject.Create(TJSONPair.Create('ip', FIP));
    lBody := TStringStream.Create(lIP.ToJSON, TEncoding.Default);

    lBody.Position := 0;
    FHttpRequest.SourceStream := lBody;

    //REQUISIÇÃO
    Result := inherited InternalExecute;
  finally
    lIP.Free;
    lBody.Free;
  end;
end;
{$ENDREGION}

end.
