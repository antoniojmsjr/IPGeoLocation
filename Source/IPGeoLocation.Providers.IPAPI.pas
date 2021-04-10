unit IPGeoLocation.Providers.IPAPI;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPAPI'}
  TIPGeoLocationProviderIPAPI = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPAPI'}
  TIPGeoLocationResponseIPAPI = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPAPI'}
  TIPGeoLocationRequestIPAPI = class sealed(TIPGeoLocationRequestCustom)
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

{$REGION 'TIPGeoLocationProviderIPAPI'}
constructor TIPGeoLocationProviderIPAPI.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPAPI';
  FURL    := 'http://api.ipapi.com';
  FAPIKey := APIKey_IPAPI; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPAPI.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPAPI.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPAPI'}
procedure TIPGeoLocationResponseIPAPI.Parse;
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
    lJSONObject.GetValue('location').TryGetValue('country_flag', FCountryFlag);
    lJSONObject.TryGetValue('country_name', FCountryName);
    lJSONObject.TryGetValue('region_name',  FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('zip',          FZipCode);
    lJSONObject.TryGetValue('isp',          FISP);
    lJSONObject.TryGetValue('latitude',     FLatitude);
    lJSONObject.TryGetValue('longitude',    FLongitude);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPAPI'}
constructor TIPGeoLocationRequestIPAPI.Create(
  pParent: IIPGeoLocationProvider; const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguageCode := 'en';
end;

function TIPGeoLocationRequestIPAPI.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIPAPI.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPAPI.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lJSONObject: TJSONObject;
  lRequestSuccessAPI: Boolean;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/%s', [FIPGeoLocationProvider.URL, 'api', FIP]));
  lURL.AddParameter('access_key', FIPGeoLocationProvider.APIKey);
  lURL.AddParameter('language', FResponseLanguageCode);
  lURL.AddParameter('output', 'json');
  lURL.AddParameter('hostname', '1');

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;

  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(Result.ContentAsString) as TJSONObject;

    //CONFORME A DOCUMENTAÇÃO DA API
    if not lJSONObject.TryGetValue('success', lRequestSuccessAPI) then
      Exit;

    if (lRequestSuccessAPI = False) then
    begin
      if Assigned(lJSONObject.GetValue('error')) then
        raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.EXCEPTION_API,
                                             FIP,
                                             FProvider,
                                             Now(),
                                             lJSONObject.GetValue('error').ToJSON);
    end;
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

end.
