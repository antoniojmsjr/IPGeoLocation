unit IPGeoLocation.Providers.IPStack;

interface

uses
  IPGeoLocation.Interfaces, IPGeoLocation.Core, System.Net.HttpClient;

type

  {$REGION 'TIPGeoLocationProviderIPStack'}
  TIPGeoLocationProviderIPStack = class sealed(TIPGeoLocationProviderCustom)
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

  {$REGION 'TIPGeoLocationResponseIPStack'}
  TIPGeoLocationResponseIPStack = class sealed(TIPGeoLocationResponseCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure Parse; override;
  public
    { public declarations }
  end;
  {$ENDREGION}

  {$REGION 'TIPGeoLocationRequestIPStack'}
  TIPGeoLocationRequestIPStack = class sealed(TIPGeoLocationRequestCustom)
  private
    { private declarations }
  protected
    { protected declarations }
    function InternalExecute: IHTTPResponse; override;
    function GetResponse(pIHTTPResponse: IHTTPResponse): IGeoLocation; override;
    function GetMessageExceptionAPI(const pJSON: string): string; override;
  public
    { public declarations }
    constructor Create(pParent: IIPGeoLocationProvider; const pIP: string); override;
  end;
  {$ENDREGION}

implementation

uses
  System.JSON, System.SysUtils, System.Net.URLClient, IPGeoLocation.Types;

{$I APIKey.inc}

{$REGION 'TIPGeoLocationProviderIPStack'}
constructor TIPGeoLocationProviderIPStack.Create(pParent: IIPGeoLocation;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FID     := '#IPSTACK';
  FURL    := 'http://api.ipstack.com';
  FAPIKey := APIKey_IPStack; //TOKEN FROM APIKey.inc
end;

function TIPGeoLocationProviderIPStack.GetRequest: IIPGeoLocationRequest;
begin
  Result := TIPGeoLocationRequestIPStack.Create(Self, FIP);
end;
{$ENDREGION}

{$REGION 'TIPGeoLocationResponseIPStack'}
procedure TIPGeoLocationResponseIPStack.Parse;
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

{$REGION 'TIPGeoLocationRequestIPStack'}
constructor TIPGeoLocationRequestIPStack.Create(pParent: IIPGeoLocationProvider;
  const pIP: string);
begin
  inherited Create(pParent, pIP);
  FResponseLanguageCode := 'en'; //English/US
end;

function TIPGeoLocationRequestIPStack.GetMessageExceptionAPI(
  const pJSON: string): string;
var
  lMessage: TStringBuilder;
  lJSONMessage: TJSONValue;
  lText: string;
begin
  lJSONMessage := nil;
  lMessage := nil;
  try
    lMessage := TStringBuilder.Create;
    lJSONMessage := TJSONObject.ParseJSONValue(pJSON);
    if not Assigned(lJSONMessage) then
      Exit(pJSON);

    (lJSONMessage as TJSONObject).TryGetValue('code', lText);
    lMessage.AppendFormat('Code: %s%s', [lText, sLineBreak]);
    (lJSONMessage as TJSONObject).TryGetValue('type', lText);
    lMessage.AppendFormat('Type: %s%s', [lText, sLineBreak]);
    (lJSONMessage as TJSONObject).TryGetValue('info', lText);
    lMessage.AppendFormat('Info: %s%s', [lText, sLineBreak]);

    Result := lMessage.ToString;
  finally
    lMessage.Free;
    lJSONMessage.Free;
  end;
end;

function TIPGeoLocationRequestIPStack.GetResponse(
  pIHTTPResponse: IHTTPResponse): IGeoLocation;
begin
  Result := TIPGeoLocationResponseIPStack.Create(pIHTTPResponse.ContentAsString, FIP, FProvider);
end;

function TIPGeoLocationRequestIPStack.InternalExecute: IHTTPResponse;
var
  lURL: TURI;
  lJSONObject: TJSONObject;
  lRequestSuccessAPI: Boolean;
  lMessageError: string;
begin
  //CONFORME A DOCUMENTAÇÃO DA API
  lURL := TURI.Create(Format('%s/%s', [FIPGeoLocationProvider.URL, FIP]));
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
      begin
        lMessageError := GetMessageExceptionAPI(lJSONObject.GetValue('error').ToJSON);
        raise EIPGeoLocationException.Create(TIPGeoLocationExceptionKind.EXCEPTION_API,
                                             FIP,
                                             FProvider,
                                             Now(),
                                             lMessageError);
      end;
    end;
  finally
    lJSONObject.Free;
  end;
end;
{$ENDREGION}

end.
