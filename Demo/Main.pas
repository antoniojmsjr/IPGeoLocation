{******************************************************************************}
{                                                                              }
{           Demo                                                               }
{                                                                              }
{           Copyright (C) Antônio José Medeiros Schneider Júnior               }
{                                                                              }
{           https://github.com/antoniojmsjr/IPGeoLocation                      }
{                                                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, IpPeerClient,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.OleCtrls, SHDocVw, ActiveX,
  System.IOUtils, System.Win.Registry, IPGeoLocation, IPGeoLocation.Types,
  IPGeoLocation.Interfaces;

type
  //Compatibility Mode

  TBrowserEmulationAdjuster = class
  private
    class function GetExeName(): String; inline;
  public const
    // Quelle: https://msdn.microsoft.com/library/ee330730.aspx, Stand: 2017-04-26
    IE11_default   = 11000;
    IE11_Quirks    = 11001;
    IE10_force     = 10001;
    IE10_default   = 10000;
    IE9_Quirks     = 9999;
    IE9_default    = 9000;
    /// <summary>
    /// Webpages containing standards-based !DOCTYPE directives are displayed in IE7
    /// Standards mode. Default value for applications hosting the WebBrowser Control.
    /// </summary>
    IE7_embedded   = 7000;
  public
    class procedure SetBrowserEmulationDWORD(const Value: DWORD);
  end;

  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel3: TPanel;
    Bevel2: TBevel;
    rstClientGetIP: TRESTClient;
    rstRequestGetIP: TRESTRequest;
    rstResponseGetIP: TRESTResponse;
    edtIP: TEdit;
    cbxProvedor: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    btnLocalizacao: TButton;
    btnIPExterno: TButton;
    mmoJSONGeolocalizacao: TMemo;
    Panel4: TPanel;
    Bevel3: TBevel;
    vleJSON: TValueListEditor;
    wbrMaps: TWebBrowser;
    Bevel4: TBevel;
    procedure btnIPExternoClick(Sender: TObject);
    procedure btnLocalizacaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vleJSONClick(Sender: TObject);
  private
    { Private declarations }
    procedure Parse(const pResponse: IGeoLocation);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.JSON, REST.Json;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  wbrMaps.Silent := True;
  TBrowserEmulationAdjuster.SetBrowserEmulationDWORD(TBrowserEmulationAdjuster.IE11_Quirks);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  wbrMaps.Navigate('about:blank');
  btnIPExterno.Click;
end;

procedure TfrmMain.btnIPExternoClick(Sender: TObject);
var
  lJSONObject: TJSONObject;
  lIP: string;
begin
  try
    rstClientGetIP.BaseURL := 'https://api.ipgeolocation.io/getip';
    rstClientGetIP.Accept  := 'application/json';

    rstRequestGetIP.Method := TRESTRequestMethod.rmGET;
    rstRequestGetIP.Execute;

    case rstResponseGetIP.StatusCode of
      200:
      begin
        if  (rstResponseGetIP.JSONValue.Null) or
        not (rstResponseGetIP.JSONValue is TJSONObject) then
          Exit;

        lJSONObject := rstResponseGetIP.JSONValue as TJSONObject;
        lJSONObject.TryGetValue('ip', lIP);

        edtIP.Clear;
        edtIP.Text := lip;
      end;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(PWideChar('IP Externo: ' + E.Message), 'A T E N Ç Ã O', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.btnLocalizacaoClick(Sender: TObject);
var
  lMsgError: string;
  lGeoLocation: IGeoLocation;
begin

  try
    lGeoLocation := TIPGeoLocation.New
      .IP[Trim(edtIP.Text)]
      .Provider[TIPGeoLocationProviderKind(cbxProvedor.ItemIndex)]
        //.SetTimeout(5000) //[OPCIONAL]
        //.SetAPIKey('TOKEN') //[OPCIONAL]: VERIFICAR ARQUIVO: APIKey.inc
      .Request
        //.SetResultLanguageCode('pt-br')//[OPCIONAL]
        .Execute;

    //RESULTA DA CONSULTA
    Parse(lGeoLocation);
  except
    on E: EIPGeoLocationRequestException do
    begin
      lMsgError := Concat(lMsgError, Format('IP: %s', [E.IP]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Provider: %s', [E.Provider]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('DateTime: %s', [DateTimeTostr(E.DateTime)]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Kind: %s', [E.Kind.AsString]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('URL: %s', [E.URL]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Method: %s', [E.Method]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Status Code: %d', [E.StatusCode]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Status Text: %s', [E.StatusText]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Message: %s', [E.Message]));

      Application.MessageBox(PWideChar(lMsgError), 'A T E N Ç Ã O', MB_OK + MB_ICONERROR);
    end;
    on E: Exception do
    begin
      Application.MessageBox(PWideChar(E.Message), 'A T E N Ç Ã O', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.Parse(const pResponse: IGeoLocation);
const
  cURLMaps = 'https://maps.google.com/maps?q=%s,%s'; //1º: LATITUDE/2º: LONGITUDE
var
  lJSONObject: TJSONObject;
  lValueJSON: string;
  lLogitude: string;
  lLatitude: string;
  I: Integer;
begin
  lJSONObject := TJSONObject.ParseJSONValue(pResponse.ToJSON, False) as TJSONObject;

  try
    mmoJSONGeolocalizacao.Clear;
    {$IF CompilerVersion > 32}
    mmoJSONGeolocalizacao.Lines.Add(lJSONObject.Format);
    {$ELSE}
    mmoJSONGeolocalizacao.Lines.Add(TJson.Format(lJSONObject));
    {$IFEND}

    Application.ProcessMessages;

    for I := 0 to Pred(vleJSON.RowCount) do
      if lJSONObject.TryGetValue(vleJSON.Keys[I].Trim, lValueJSON) then
        vleJSON.Cells[1, I] := lValueJSON;

    lJSONObject.TryGetValue('latitude', lLatitude);
    lJSONObject.TryGetValue('longitude', lLogitude);

    Application.ProcessMessages;
  finally
    if Assigned(lJSONObject) then
      FreeAndNil(lJSONObject);
  end;

  if (lLatitude <> EmptyStr) and
     (lLogitude <> EmptyStr) then
    wbrMaps.Navigate(Format(cURLMaps, [lLatitude, lLogitude]));
end;

procedure TfrmMain.vleJSONClick(Sender: TObject);
begin

end;

{ TBrowserEmulationAdjuster }

class function TBrowserEmulationAdjuster.GetExeName: String;
begin
  Result := TPath.GetFileName(ParamStr(0));
end;

class procedure TBrowserEmulationAdjuster.SetBrowserEmulationDWORD(
  const Value: DWORD);
const
  cRegistryPath = 'Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION';
var
  lRegistry: TRegistry;
  lExeName: String;
begin
  lExeName := GetExeName();

  lRegistry := TRegistry.Create(KEY_SET_VALUE);
  try
    lRegistry.RootKey := HKEY_CURRENT_USER;
    Win32Check(lRegistry.OpenKey(cRegistryPath, True));
    lRegistry.WriteInteger(lExeName, Value)
  finally
    lRegistry.Free();
  end;
end;

end.
