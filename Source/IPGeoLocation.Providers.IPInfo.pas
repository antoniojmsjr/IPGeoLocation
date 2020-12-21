unit IPGeoLocation.Providers.IPInfo;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPInfo'}
  TIPGeoLocationProviderIPInfo = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPInfo'}
  TIPGeoLocationResponseIPInfo = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPInfo'}
  TIPGeoLocationRequestIPInfo = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IGeoLocation; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPInfo'}
constructor TIPGeoLocationProviderIPInfo.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPINFO';
  FURL    := 'https://ipinfo.io'; //HTTPS
  FAPIKey := APIKey_IPInfo; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPInfo.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPInfo.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPInfo'}
procedure TIPGeoLocationResponseIPInfo.Parse;
var
  lJSONObject: TJSONObject;
  lCoordinates: string;
  lCoordinatesArray: TArray<string>;
  lFormatSettings: TFormatSettings;
begin
  lJSONObject := nil;
  try
    lJSONObject := TJSONObject.ParseJSONValue(FJSON) as TJSONObject;
    if not Assigned(lJSONObject) then
      Exit;

    lJSONObject.TryGetValue('hostname', FHostName);
    lJSONObject.TryGetValue('city',     FCity);
    lJSONObject.TryGetValue('region',   FState);
    lJSONObject.TryGetValue('country',  FCountryCode);
    lJSONObject.TryGetValue('loc',      lCoordinates);
    lJSONObject.TryGetValue('org',      FISP);
    lJSONObject.TryGetValue('postal',   FZipCode);
    lJSONObject.TryGetValue('timezone', FTimeZoneName);

    lCoordinatesArray := lCoordinates.Split([',']);
    if (Length(lCoordinatesArray) >= 2) then
    begin
      lFormatSettings := TFormatSettings.Create('en-US');
      TryStrToFloat(lCoordinatesArray[0], FLatitude,  lFormatSettings);
      TryStrToFloat(lCoordinatesArray[1], FLongitude, lFormatSettings);
    end;
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationRequestIPInfo'}
function TIPGeoLocationRequestIPInfo.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIPInfo.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPInfo.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s', [FIPGeoLocationProvider.URL, FIP]));
  FRequestHeaders := [TNameValuePair.Create('Authorization',
                                     Format('%s %s', ['Bearer', FIPGeoLocationProvider.APIKey]))];

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
