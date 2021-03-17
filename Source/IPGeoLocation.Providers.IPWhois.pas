unit IPGeoLocation.Providers.IPWhois;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPWhois'}
  TIPGeoLocationProviderIPWhois = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPWhois'}
  TIPGeoLocationResponseIPWhois = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPWhois'}
  TIPGeoLocationRequestIPWhois = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IGeoLocation; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string); override;
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient, IPGeoLocation.Types;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPWhois'}
constructor TIPGeoLocationProviderIPWhois.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPWHOIS';
  FURL    := 'http://ipwhois.app';
  FAPIKey := APIKey_IPWhois; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPWhois.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPWhois.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPWhois'}
procedure TIPGeoLocationResponseIPWhois.Parse;
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
    lJSONObject.TryGetValue('country_flag', FCountryFlag);
    lJSONObject.TryGetValue('region',       FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('latitude',     FLatitude);
    lJSONObject.TryGetValue('longitude',    FLongitude);
    lJSONObject.TryGetValue('isp',          FISP);
    lJSONObject.TryGetValue('timezone',     FTimeZoneName);
    lJSONObject.TryGetValue('timezone_gmt', FTimeZoneOffset);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPWhois'}
constructor TIPGeoLocationRequestIPWhois.Create(pParent: IIPGeoLocationProvider;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguageCode := 'pt-BR';
end;

function TIPGeoLocationRequestIPWhois.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIPWhois.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPWhois.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lJSONObject: TJSONObject;
  lRequestSuccessAPI: Boolean;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/%s', [FIPGeoLocationProvider.URL, 'json', FIP]));
  lURL.AddParameter('lang', FResponseLanguageCode);

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;

  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(Result.ContentAsString) as TJSONObject;

    lJSONObject.TryGetValue('success', lRequestSuccessAPI);
    if (lRequestSuccessAPI = False) then
    begin
      if Assigned(lJSONObject.GetValue('message')) then
        raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                             FProvider,
                                             lJSONObject.GetValue('message').ToString);
    end;
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

end.
