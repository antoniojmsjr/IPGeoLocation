unit IPGeoLocation.Providers.IP_API;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIP_Api'}
  TIPGeoLocationProviderIP_Api = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIP_Api'}
  TIPGeoLocationResponseIP_Api = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIP_Api'}
  TIPGeoLocationRequestIP_Api = class sealed(TIPGeoLocationRequestCustom)
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

{$REGION 'TIPGeoLocationProviderIP_Api'}
constructor TIPGeoLocationProviderIP_Api.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IP-API';
  FURL    := 'http://ip-api.com';
  FAPIKey := APIKey_IP_API; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIP_Api.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIP_Api.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIP_Api'}
procedure TIPGeoLocationResponseIP_Api.Parse;
var
  lJSONObject: TJSONObject;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('country',      FCountryName);
    lJSONObject.TryGetValue('countryCode',  FCountryCode);
    lJSONObject.TryGetValue('regionName',   FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('district',     FDistrict);
    lJSONObject.TryGetValue('zip',          FZipCode);
    lJSONObject.TryGetValue('lat',          FLatitude);
    lJSONObject.TryGetValue('lon',          FLongitude);
    lJSONObject.TryGetValue('isp',          FISP);
    lJSONObject.TryGetValue('timezone',     FTimeZoneName);
    lJSONObject.TryGetValue('offset',       FTimeZoneOffset);
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIP_Api'}
constructor TIPGeoLocationRequestIP_Api.Create(pParent: IIPGeoLocationProvider;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguageCode := 'pt-BR';
end;

function TIPGeoLocationRequestIP_Api.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIP_Api.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIP_Api.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lJSONObject: TJSONObject;
  lRequestStatus: string;
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

    lJSONObject.TryGetValue('status', lRequestStatus);
    if (lRequestStatus = 'fail') then
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
