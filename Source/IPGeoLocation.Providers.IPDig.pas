unit IPGeoLocation.Providers.IPDig;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPDig'}
  TIPGeoLocationProviderIPDig = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPDig'}
  TIPGeoLocationResponseIPDig = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPDig'}
  TIPGeoLocationRequestIPDig = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string); override;
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPDig'}
constructor TIPGeoLocationProviderIPDig.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPDIG';
  FURL    := 'https://ipdig.io';
  FAPIKey := APIKey_IPDig; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPDig.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPDig.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPDig'}
procedure TIPGeoLocationResponseIPDig.Parse;
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

    lJSONObject.TryGetValue('country',      FCountryCode);
    lJSONObject.TryGetValue('country_full', FCountryName);
    lJSONObject.TryGetValue('region',       FState);
    lJSONObject.TryGetValue('city',         FCity);
    lJSONObject.TryGetValue('postal',       FZipCode);
    lJSONObject.TryGetValue('loc',          lCoordinates);
    lJSONObject.TryGetValue('organization', FISP);

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

{$REGION 'TIPGeoLocationRequestIPDig'}
constructor TIPGeoLocationRequestIPDig.Create(pParent: IIPGeoLocationProvider;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FCheckJSONValue := False;
end;

function TIPGeoLocationRequestIPDig.GetResponse(
  pIHTTPResponse: IHTTPResponse): IIPGeoLocationResponse;
begin
  Result := TIPGeoLocationResponseIPDig.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPDig.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s', [FIPGeoLocationProvider.URL, FIP]));

  FHttpRequest.URL := lURL.ToString;

  //REQUISIÇÃO
  Result := inherited InternalExecute;
end;
{$ENDREGION}

end.
