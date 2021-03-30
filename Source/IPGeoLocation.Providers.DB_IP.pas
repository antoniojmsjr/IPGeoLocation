unit IPGeoLocation.Providers.DB_IP;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderDB_IP'}
  TIPGeoLocationProviderDB_IP = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseDB_IP'}
  TIPGeoLocationResponseDB_IP = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestDB_IP'}
  TIPGeoLocationRequestDB_IP = class sealed(TIPGeoLocationRequestCustom)
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

{$REGION 'TIPGeoLocationProviderDB_IP'}
constructor TIPGeoLocationProviderDB_IP.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#DB-IP';
  FURL    := 'http://api.db-ip.com';
  FAPIKey := APIKey_DB_IP; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderDB_IP.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestDB_IP.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationProviderDB_IP'}
procedure TIPGeoLocationResponseDB_IP.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('countryCode',  FCountryCode);
    lJSONObject.TryGetValue('countryName ', FCountryName);
    lJSONObject.TryGetValue('stateProv',    FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('district',     FDistrict);
    lJSONObject.TryGetValue('zipCode',      FZipCode);
    lJSONObject.TryGetValue('latitude',     FLatitude);
    lJSONObject.TryGetValue('longitude',    FLongitude);
    lJSONObject.TryGetValue('timeZone',     FTimeZoneName);
    lJSONObject.TryGetValue('gmtOffset',    FTimeZoneOffset);
    lJSONObject.TryGetValue('isp',          FISP);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestDB_IP'}
constructor TIPGeoLocationRequestDB_IP.Create(pParent: IIPGeoLocationProvider;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguageCode := 'en-US';
end;

function TIPGeoLocationRequestDB_IP.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseDB_IP.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestDB_IP.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lJSONObject: TJSONObject;
  lRequestError: string;
  lRequestMessage: string;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s/%s/%s', [
                      FIPGeoLocationProvider.URL, 'v2', FIPGeoLocationProvider.APIKey, FIP]));

  FHttpRequest.URL := lURL.ToString;
  FHttpRequest.CustomHeaders['Accept-Language'] := FResponseLanguageCode;

  //REQUISIÇÃO
  Result := inherited InternalExecute;

  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(Result.ContentAsString) as TJSONObject;

    lJSONObject.TryGetValue('errorCode', lRequestError);
    if (lRequestError <> EmptyStr) then
    begin
      lRequestMessage := Format('%s: %s', [lJSONObject.GetValue('errorCode').ToString, lJSONObject.GetValue('error').ToString]);
      raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.iglEXCEPTION_API,
                                           FIP,
                                           FProvider,
                                           Now(),
                                           lRequestMessage);
    end;
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

end.
