{******************************************************************************}
{                                                                              }
{           Demo                                              }
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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ValEdit, Vcl.OleCtrls, SHDocVw;

type
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
  private
    { Private declarations }
    procedure ResultJSON(const Value: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.JSON, REST.Json, IPGeoLocation, IPGeoLocation.Types;

{$R *.dfm}

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
        if (rstResponseGetIP.JSONValue.Null) or
            not (rstResponseGetIP.JSONValue is TJSONObject) then
          Exit;

        try
          lJSONObject :=
            TJSONObject.ParseJSONValue(rstResponseGetIP.JSONValue.ToString) as TJSONObject;

          lJSONObject.TryGetValue('ip', lIP);

          edtIP.Clear;
          edtIP.Text := lip;
        finally
          if Assigned(lJSONObject) then
            FreeAndNil(lJSONObject);
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;

end;

procedure TfrmMain.btnLocalizacaoClick(Sender: TObject);
begin
  try
    TIPGeoLocation
    .New
      .IP[edtIP.Text]
      .Provider[TIPGeoLocationProviderType(cbxProvedor.ItemIndex)]
        .Settings
      .Request
        .Execute
        .ToJSON(ResultJSON);
  except
    on E: EIPGeoLocationRequestException do
    begin
      var lMsg: string := EmptyStr;
      lMsg := Concat(lMsg, Format('Provider: %s', [E.Provider]), sLineBreak);
      lMsg := Concat(lMsg, Format('Kind: %s', [IPGeoLocationExceptionKindToString(E.Kind)]), sLineBreak);
      lMsg := Concat(lMsg, Format('URL: %s', [E.URL]), sLineBreak);
      lMsg := Concat(lMsg, Format('Method: %s', [E.Method]), sLineBreak);
      lMsg := Concat(lMsg, Format('Status Code: %d', [E.StatusCode]), sLineBreak);
      lMsg := Concat(lMsg, Format('Status Text: %s', [E.StatusText]), sLineBreak);
      lMsg := Concat(lMsg, Format('Message: %s', [E.Message]));

      Application.MessageBox(PWideChar(lMsg), 'ATENÇÃO', MB_OK + MB_ICONERROR);
    end;
    on E: Exception do
    begin
      Application.MessageBox(PWideChar(E.Message), 'ATENÇÃO', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  btnIPExterno.Click;
end;

procedure TfrmMain.ResultJSON(const Value: string);
const
  cURLMaps = 'https://www.google.com/maps/search/?api=1&query=%s,%s';
var
  lJSONObject: TJsonObject;
  lValueJSON: string;
  lLogitude: string;
  lLatitude: string;
begin
  lJSONObject := TJSONObject.ParseJSONValue(Value, False, False) as TJsonObject;

  try
    mmoJSONGeolocalizacao.Clear;
    mmoJSONGeolocalizacao.Lines.Add(lJSONObject.Format());

    for var I := 0 to Pred(vleJSON.RowCount) do
      if lJSONObject.TryGetValue(vleJSON.Keys[I], lValueJSON) then
        vleJSON.Cells[1, I] := lValueJSON;
  
    lJSONObject.TryGetValue('latitude', lLatitude);
    lJSONObject.TryGetValue('longitude', lLogitude);
  finally
    if Assigned(lJSONObject) then
      FreeAndNil(lJSONObject);
  end;

  if (lLatitude <> EmptyStr) and 
     (lLogitude <> EmptyStr) then
  begin
    wbrMaps.Stop;

    //https://developers.google.com/maps/documentation/urls/guide
    wbrMaps.Navigate(Format(cURLMaps, [lLatitude, lLogitude]));
  end;
  
end;

end.
