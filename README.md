![Maintained YES](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-Tokyo%2010.2.3%20and%20ever-blue.svg)
![Platforms](https://img.shields.io/badge/Platforms-Win32%20and%20Win64-red.svg)
![Compatibility](https://img.shields.io/badge/Compatibility-VCL,%20Firemonkey,%20DataSnap%20-brightgreen.svg)

<p align="center">
  <a href="https://github.com/antoniojmsjr/IPGeoLocation/blob/master/Image/logo.png">
    <img alt="IPGeolocation" height="150" src="https://github.com/antoniojmsjr/IPGeoLocation/blob/master/Image/logo.png">
  </a>
</p>

# IPGeoLocation

Biblioteca de geolocalização por IP.

Implementado na linguagem Delphi e utiliza interfaces fluentes para guiar no uso da biblioteca.</br>
A biblioteca foi desenvolvida utilizando os principais players do mercado de solução de "IP-Geolocation", em anexo a lista dos provedores homologados.

## O que é a geolocalização de IP?

A geolocalização baseada em endereços IP é uma técnica usada para estimar a localização geográfica de um dispositivo conectado à Internet usando o endereço IP do mesmo.  Este mecanismo depende de que o endereço IP do dispositivo apareça em um banco de dados com sua respectiva localização, endereço postal, cidade, país, região ou coordenadas geográficas, que são alguns dos níveis de detalhe que podem ser registrados.

Para mais informações: [Geolocalização de IPs](https://www.lacnic.net/3107/3/lacnic/geolocalizac%C3%A3o-de-ips)

## Para que?

Essa tecnologia é amplamente usada em:

* Geo Marketing
  * Propagandas direcionadas/sob medida
  * Informação interessante com base na localização
  * Promoções/campanhas destinadas a certo público/local
  * Empresas de turismo, companhias aéreas, redes hoteleiras
  * Entretenimento

* Direcionamento de conteúdo
  * Portais “globais” com conteúdos “locais”
  * Informações no idioma do leitor
  * Conteúdo de interesse local (notícia, novidades, etc)
  * Portais de notícias
  * Serviços de informação meteorológica
  * Serviços de emergência

* Controle de acesso (à conteúdos/serviços)
  * Restringir acesso conteúdo/serviços com base na “localização” do usuário
  * Conteúdos específicos para determinado “público”
  * Censura
  * Jogos online
  * Streaming vídeos/músicas

* Segurança
  * Restringir tráfego, por localização do usuário
  * Em situação de emergência/ataque descartar tráfego “não esperado”
  * Controle de SPAM
  * Firewalls

## Provedores Homologados

| Provedor | Site | API |
|---|---|---|
| IP2Location | https://www.ip2location.com | https://api.ip2location.com/v2 |
| IPGeolocation | https://ipgeolocation.io | https://api.ipgeolocation.io/ipgeo |
| IPStack  | https://ipstack.com | http://api.ipstack.com |
| IPIfy | https://geo.ipify.org | https://geo.ipify.org/api/v1 |
| IPAPI | https://ipapi.com | http://api.ipapi.com/api |
| IPInfo | https://ipinfo.io | https://ipinfo.io |
| IPGeolocation API | https://ipgeolocationapi.com | https://api.ipgeolocationapi.com/geolocate |
| IPWhois | https://ipwhois.io | http://ipwhois.app |
| IPDig | https://ipdig.io | https://ipdig.io |

## Demo
[![Download](https://img.shields.io/badge/Download-Demo.zip-orange.svg)](https://github.com/antoniojmsjr/IPGeoLocation/files/4074834/Demo.zip)

```delphi
uses IPGeoLocation, IPGeoLocation.Interfaces, IPGeoLocation.Types;
```

```delphi
var
  lMsgError: string;
begin
  try
    TIPGeoLocation.New
      .IP[Trim(edtIP.Text)]
      .Provider[TIPGeoLocationProviderKind(cbxProvedor.ItemIndex)]
        .Settings
      .Request
        .Execute
        .OnResponse(DoResponse);
  except
    on E: EIPGeoLocationRequestException do
    begin
      lMsgError := Concat(lMsgError, Format('Provider: %s', [E.Provider]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Kind: %s', [E.Kind.AsString]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('URL: %s', [E.URL]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Method: %s', [E.Method]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Status Code: %d', [E.StatusCode]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Status Text: %s', [E.StatusText]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Message: %s', [E.Message]));

      Application.MessageBox(PWideChar(lMsgError), 'W A R N I N G', MB_OK + MB_ICONERROR);
    end;
    on E: Exception do
    begin
      Application.MessageBox(PWideChar(E.Message), 'W A R N I N G', MB_OK + MB_ICONERROR);
    end;
  end;
end;
```
![IP Geolocalização](https://user-images.githubusercontent.com/20980984/70379772-a2843a80-190f-11ea-98b7-2bde17365438.png)

## Youtube
[![Vídeo Youtube](https://user-images.githubusercontent.com/20980984/72579261-5c7ba880-38b7-11ea-9b20-942d806a14d9.png)](https://www.youtube.com/watch?v=x8CVAudNkSY)

## Licença
[![License](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://github.com/antoniojmsjr/IPGeoLocation/blob/master/LICENSE)
